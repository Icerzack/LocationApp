from telethon import TelegramClient, events, sync
from DB import db


def send_alarm(user_id):
    print("Telgram: bla-bla-bla ALARM!")
    last_steps = db.get_points(user_id)
    message_content = 'Telegram: his last steps were: '
    for step in last_steps:
        message_content += str(step) + ", "
    message_content = message_content[:-2]
    print(message_content)
    send_message(message_content)


# Sender function
def send_message(message_content):
    user_details = '@maxalkuz'

    # These API codes wont work, hence create your own
    api_id = 5303125
    api_hash = '1a422b55b374e79fa4dc8fa9b9f83cfc'

    client = TelegramClient('session_name_al1', api_id, api_hash)
    client.start()
    client.send_message(user_details, message_content)

