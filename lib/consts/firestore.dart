const String USERS_COLLECTION = 'users',
    USER_DISPLAY_NAME = 'displayName',
    USER_EMAIL = 'email',
    USER_EMAIL_VERIFIED = 'emailVerified',
    USER_UID = 'uid',
    USER_IMAGE_REFERENCE = 'imageRef';

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
    MESSAGE_SENDER_UID = 'senderUid',
    MESSAGE_TEXT = 'text',
    MESSAGE_TIME_SENT = 'timeSent';

const String CHATS_COLLECTION = 'chats',
    CHAT_DATE_CREATED = 'dateCreated',
    CHAT_PEERS = 'peerUids',
    CHAT_OFFER_ID = 'offerId',
    CHAT_DATABASE_REF = 'databaseRef';

const String STORAGE_DEFAULT_BUCKET = 'gs://reso-83572.appspot.com/',
    STORAGE_IMAGE_BUCKET = 'gs://images-bkfz5/',
    DEFAULT_PROFILE_IMAGE_PATH =
        STORAGE_IMAGE_BUCKET + 'default_profile_image.png';
