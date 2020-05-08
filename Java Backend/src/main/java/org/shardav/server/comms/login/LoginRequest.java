package org.shardav.server.comms.login;

import org.json.JSONObject;
import org.shardav.server.comms.Request;

public class LoginRequest<T extends UserDetails> extends Request<T> {

    /**
     * Constructor used to create a new login request
     *
     * @param details An instance of login details containing the username and password
     */
    private LoginRequest(T details) {
        super(RequestType.login, details);
    }

    /**
     * Fetches the details of the current LoginRequest
     *
     * @return An instance of LoginDetails object
     */
    @Override
    public T getDetails() {
        return this.details;
    }

    /**
     * Fetches an instance of LoginRequest from the JSONObject provided
     *
     * @param loginObject A object of type JSONObject that represents a login request
     * @return An instance of class login request with all the fields satisfied
     * @throws IllegalArgumentException Thrown if the request is invalid
     */
    public static LoginRequest<UserDetails> getInstance(JSONObject loginObject)throws IllegalArgumentException {

        if(loginObject.has("request") && loginObject.getString("request")!=null
                && loginObject.has("details") && loginObject.getJSONObject("details")!=null){
            RequestType request = RequestType.valueOf(loginObject.getString("request"));
            if(request == RequestType.login){
                return new LoginRequest<>(UserDetails.getInstance(loginObject.getJSONObject("details")));
            } else if (request == RequestType.registration){
                UserDetails details = UserDetails.getInstance(loginObject.getJSONObject("details"));
                if(details.hasEmail() && details.hasUsername() && details.hasPassword())
                    return new LoginRequest<>(details);
                else
                    throw new IllegalArgumentException("Invalid registration request, email, username and password should be present.");
            } else {
                throw new IllegalArgumentException("Invalid request type. First request should be login");
            }
        } else
            throw new IllegalArgumentException("Keys 'request' or 'details' is either not present or is null");

    }

}
