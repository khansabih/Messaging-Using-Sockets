package org.shardav.server.comms.messages;

import org.shardav.server.comms.Details;

import java.util.HashMap;
import java.util.Map;

public class MessageDetails implements Details {

    private String id;
    private final String message;
    private String media;
    private String from;

    private final long time;

    /**
     * Message without any media
     *
     * @param id the id of the message, it should be unique for future purposes
     * @param message the body of the message to be sent
     * @param time the time at which the message was sent
     * @param from the person who sent the message
     */
    protected MessageDetails(String id, String message, long time, String from) {
        this.id = id;
        this.message = message;
        this.time = time;
        this.media = null;
        this.from = from;
    }

    /**
     * Message with media
     * @param id the id of the message, it should be unique for future purposes
     * @param message the body of the message to be sent
     * @param media the media of the message
     * @param time the time at which the message was sent
     * @param from the person who sent the message
     */
    protected MessageDetails(String id, String message, String media, long time, String from) {
        this(id,message, time, from);
        this.media = media;
    }

    /**
     * Fetch the id of the message
     * @return Returns the id of the current message.
     */
    public String getId() {
        return id;
    }

    /**
     * Fetch the body of the current message
     * @return Returns the body of the current message.
     */
    public String getMessage() {
        return message;
    }

    /**
     * Fetch the url of the media of the message
     * @return Returns the url of the media of the current message.
     */
    public String getMedia() {
        return media;
    }

    /**
     * Fetch the sender of the message
     * @return Returns the sender of the current message.
     */
    public String getFrom() {
        return from;
    }

    /**
     * Fetch the timestamp of the message
     * @return Returns the timestamp of the current message.
     */
    public long getTime() {
        return time;
    }

    /**
     * Set the sender username
     * @param from username of the sender
     */
    public MessageDetails setFrom(String from) {
        this.from = from;
        return MessageDetails.this;
    }

    public MessageDetails setId(String id) {
        this.id = id;
        return MessageDetails.this;
    }

}
