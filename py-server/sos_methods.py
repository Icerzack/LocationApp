import tebot
from DB import db


def sos_router(json_request):
    print(f"Event:{json_request['event']}", flush=True)

    if json_request['event'] == 'start_timer':
        response = start_timer(json_request['user_id'],
                               json_request['timer_value'])
    elif json_request['event'] == 'cancel_timer':
        response = cancel_timer(json_request['user_id'])
    elif json_request['event'] == 'alarm_button':
        response = alarm_button(json_request['user_id'],
                                (json_request['coords']['x'],
                                 json_request['coords']['y']))
    elif json_request['event'] == 'interval_timer':
        response = interval_timer(json_request['user_id'],
                                  (json_request['coords']['x'],
                                   json_request['coords']['y']))
    else:
        response = "Something went wrong! INcorrect request!"

    return response


def start_timer(user_id, time_value):
    '''{"event":"start_timer","user_id":2342,"timer_value":24424}'''
    response = db.add_timer(user_id, time_value)

    return response


def alarm_button(user_id, coords):

    response = db.add_point(user_id, coords)
    tebot.send_alarm(user_id)

    print("alarm_button(): respose-", response, flush=True)
    return response


def cancel_timer(user_id):
    return True


def interval_timer(user_id, coords):
    response = db.add_point(user_id, coords)
    return response
