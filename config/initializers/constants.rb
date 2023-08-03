EMAIL_REGEX = /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i
ADMIN_EMAIL = "admin@depot.com"
IMAGE_URL_REGEX = /\Ahttps?:\/\/[\S]+\.(gif|jpg|png)\z/
PERMALINK_REGEX = /\A[a-z0-9-]+\z/i.freeze
DESCRIPTION_WORDS_REGEX = /[a-z0-9]+/i.freeze
CATEGORY_ID_REGEX = /[\d]+/.freeze
FIREFOX_BROWSER_REGEX = /firefox/i.freeze
