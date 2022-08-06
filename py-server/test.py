# import json
# {"event":"alarm_button", "user_id":1, "coords":{"x":789.23, "y":23.4}}
# request = b'{"event":"start_button","user_id":1,"timer_value":244242, "coords":{"x":789.23, "y":23.4}}\n'
# request = request.decode()
# req = json.loads(request)
# response = str((req['user_id'], req['coords']))
# print(response)
#
# import aserver

# sudo apt-get install libpq-dev python3-dev

from DB import db
# db.add_timer(2, 543)
# db.add_timer(1, 1345)
for r in db.get_timers_by_time('2 days 1 hour 30 minutes 20 seconds'):
    for j in r:
        print(j, end="   ")
    print("\n")
# db.cursor.execute('''CREATE TABLE timer (USER_ID   INT        NOT NULL REFERENCES USER_INFO (ID),
#                       END_TIME  TIMESTAMP  NOT NULL,
#                       TYPE      CHAR(15)   NOT NULL);''')
# db.connection.commit()

# print(db.get_points(1, '2 days'))
# from tebot import send_alarm
#
# send_alarm(1)