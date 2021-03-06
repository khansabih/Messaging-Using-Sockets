package org.shardav.server.sql;

import org.shardav.server.Server;
import org.shardav.server.comms.login.UserDetails;
import org.shardav.server.comms.messages.Message;
import org.shardav.server.comms.messages.PersonalMessageDetails;
import org.shardav.utils.Log;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Database {

    private final Connection connection;
    private static Database instance;

    private final PreparedStatement VIEW_MESSAGES_BY_EMAIL;
    private final PreparedStatement FETCH_USER_DETAILS_BY_EMAIL;
    private final PreparedStatement FETCH_USER_DETAILS_BY_USERNAME;
    private final PreparedStatement DELETE_USER_BY_EMAIL;

    private static final Object LOCK = new Object();

    private static final String LOG_TAG = Server.class.getSimpleName() + ": " + Database.class.getSimpleName();

    private Database(String host, String port, String username, String password) throws SQLException {

        final String MYSQL_BASE_URL_FORMAT = "jdbc:mysql://%s:%s";

        connection = DriverManager.getConnection(String.format(MYSQL_BASE_URL_FORMAT, host, port), username, password);
        connection.setAutoCommit(true);

        Statement statement = connection.createStatement();

        statement.executeUpdate(SQLStatements.CREATE_DATABASE);
        statement.executeUpdate(SQLStatements.USE_DATABASE);

        statement.executeUpdate(SQLStatements.CREATE_TABLE_USERS);
        statement.executeUpdate(SQLStatements.CREATE_TABLE_PRIVATE_MESSAGES);

        VIEW_MESSAGES_BY_EMAIL = connection.prepareStatement(SQLStatements.VIEW_MESSAGES_BY_EMAIL);
        FETCH_USER_DETAILS_BY_EMAIL = connection.prepareStatement(SQLStatements.FETCH_USER_DETAILS_BY_EMAIL);
        FETCH_USER_DETAILS_BY_USERNAME = connection.prepareStatement(SQLStatements.FETCH_USER_DETAILS_BY_USERNAME);
        DELETE_USER_BY_EMAIL = connection.prepareStatement(SQLStatements.DELETE_USER_BY_EMAIL);

    }

    public static Database getInstance(String username, String password) throws SQLException, InstantiationException {
        return getInstance("localhost", username, password);
    }

    public static Database getInstance(String host, String username, String password) throws SQLException, InstantiationException {
        return getInstance(host, "3306", username, password);
    }

    public static Database getInstance(String host, String port, String username, String password) throws SQLException, InstantiationException {
        synchronized (LOCK) {
            if (instance == null) {
                instance = new Database(host, port, username, password);
                return instance;
            } else {
                throw new InstantiationException("An instance of the database already exists");
            }
        }
    }

    public static Database getInstance() throws InstantiationException {
        synchronized (LOCK) {
            if (instance != null) {
                return instance;
            } else {
                throw new InstantiationException("An instance of the database already exists");
            }
        }
    }

    public void addMessage(PersonalMessageDetails details) throws SQLException {

        String statement;

        if (details.getMedia() == null) {
            statement = String.format(SQLStatements.INSERT_INTO_PRIVATE_MESSAGES_WITHOUT_MEDIA,
                    details.getId(),
                    details.getTo(),
                    details.getFrom(),
                    details.getMessage(),
                    details.getTime());
        } else if (details.getMessage() == null) {
            statement = String.format(SQLStatements.INSERT_INTO_PRIVATE_MESSAGES_WITHOUT_MESSAGES,
                    details.getId(),
                    details.getTo(),
                    details.getFrom(),
                    details.getMedia(),
                    details.getTime());
        } else {
            statement = String.format(SQLStatements.INSERT_INTO_PRIVATE_MESSAGES_WITH_MEDIA,
                    details.getId(),
                    details.getTo(),
                    details.getFrom(),
                    details.getMedia(),
                    details.getMessage(),
                    details.getTime());
        }

        Statement insertMessage = connection.createStatement();
        int rows = insertMessage.executeUpdate(statement);

        Log.v(LOG_TAG, "Message " + details.getId() + " inserted into database, " + rows + " affected.");

    }

    public void deleteUserByEmail(String email) throws SQLException {
        DELETE_USER_BY_EMAIL.clearParameters();
        DELETE_USER_BY_EMAIL.setString(1, email);

        DELETE_USER_BY_EMAIL.execute();
    }

    public void insertUser(UserDetails details) throws SQLException {

        String statement = String.format(SQLStatements.INSERT_USER,
                details.getEmail(),
                details.getUsername(),
                details.getPassword());

        Statement insertUser = connection.createStatement();
        int rows = insertUser.executeUpdate(statement);

        Log.v(LOG_TAG, "User " + details.getUsername() + " inserted into database, " + rows + " affected.");

    }

    public List<Message<PersonalMessageDetails>> fetchMessagesByEmail(String email) throws SQLException {
        List<Message<PersonalMessageDetails>> messages = new ArrayList<>();

        VIEW_MESSAGES_BY_EMAIL.clearParameters();
        VIEW_MESSAGES_BY_EMAIL.setString(1, email);

        ResultSet result = VIEW_MESSAGES_BY_EMAIL.executeQuery();

        while (result.next()) {
            messages.add(new Message<>(new PersonalMessageDetails(
                    result.getString("id"), //ID
                    result.getString("message"), //Message
                    result.getString("media"), //Media
                    result.getLong("time"), //Timestamp
                    result.getString("sender"), //Sender
                    result.getString("receiver")  //Recipient
            )));
        }

        result.close();

        if (messages.isEmpty())
            return null;
        return messages;
    }

    public UserDetails fetchUserDetailsByUsername(String username) throws SQLException {

        FETCH_USER_DETAILS_BY_USERNAME.clearParameters();
        FETCH_USER_DETAILS_BY_USERNAME.setString(1, username);

        ResultSet result = FETCH_USER_DETAILS_BY_USERNAME.executeQuery();

        UserDetails userDetails = null;

        if (result.next())
            userDetails = new UserDetails(
                    result.getString("email"),
                    username,
                    result.getString("password")
            );

        result.close();

        return userDetails;

    }

    public UserDetails fetchUserDetailsByMail(String email) throws SQLException, IllegalArgumentException {

        FETCH_USER_DETAILS_BY_EMAIL.clearParameters();
        FETCH_USER_DETAILS_BY_EMAIL.setString(1, email);

        ResultSet result = FETCH_USER_DETAILS_BY_EMAIL.executeQuery();

        UserDetails userDetails = null;

        if (result.next()) {
            userDetails = new UserDetails(
                    email,
                    result.getString("username"),
                    result.getString("password")
            );
        }

        result.close();

        return userDetails;

    }

    public List<UserDetails> fetchUserList() throws SQLException {

        List<UserDetails> users = new ArrayList<>();

        Statement viewUserList = connection.createStatement();

        ResultSet result = viewUserList.executeQuery(SQLStatements.VIEW_USER_LIST);

        while (result.next()) {
            users.add(new UserDetails(
                    result.getString("email"),
                    result.getString("username")
            ));
        }

        result.close();

        return users;

    }

    public void close() throws SQLException {

        instance = null;
        if (!connection.isClosed())
            connection.close();

    }

}
