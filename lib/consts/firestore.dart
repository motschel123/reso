const String USERS_COLLECTION = 'users',
    USER_DISPLAY_NAME = 'displayName',
    USER_EMAIL = 'email',
    USER_EMAIL_VERIFIED = 'emailVerified',
    USER_UID = 'uid',
    USER_IMAGE_URL = 'imageUrl',
    USER_IMAGE_REF = 'imageRef';

/// Collection of all [Offer]'s at root ('/OFFER_COLLECTION') of firestore
const String OFFERS_COLLECTION = 'offers',
    OFFER_DATE_CREATED = 'dateCreated',
    OFFER_DESCRIPTION = 'description',
    OFFER_IMAGE_REFERENCE = 'imageRef',
    OFFER_IMAGE_URL = 'imageUrl',
    OFFER_LOCATION = 'location',
    OFFER_PRICE = 'price',
    OFFER_TITLE = 'title',
    OFFER_TYPE = 'type',
    OFFER_AUTHOR_UID = 'authorUid',
    OFFER_AUTHOR_DISPLAY_NAME = 'authorDisplayName',
    OFFER_AUTHOR_IMAGE_URL = 'authorImageUrl',
    OFFER_DATE_EVENT = 'dateEvent',
    OFFER_TYPE_SERVICE = 'OfferType.service',
    OFFER_TYPE_PRODUCT = 'OfferType.product',
    OFFER_TYPE_FOOD = 'OfferType.food',
    OFFER_TYPE_ACTIVITY = 'OfferType.activity';

const String MESSAGES_COLLECTION = 'messages',
    MESSAGE_RECEIVER_UID = 'receiverUid',
    MESSAGE_SENDER_UID = 'senderUid',
    MESSAGE_TEXT = 'text',
    MESSAGE_TIME_RECEIVED = 'timeReceived',
    MESSAGE_TIME_SENT = 'timeSent',
    MESSAGE_TIME_ONLINE = 'timeOnline';

const String CHATS_COLLECTION = 'chats',
    CHAT_DATE_CREATED = 'dateCreated',
    CHAT_PEERS = 'peerUids',
    CHAT_OFFER_ID = 'offerId';

const String STORAGE_BUCKET_URL = 'gs://reso-83572.appspot.com/';
