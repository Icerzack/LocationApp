from config import *
import psycopg2


class Database:
    # ''' table user_info (
    #     ID        serial               NOT NULL PRIMARY KEY ,
    #     user_name char(50)   not null,
    #     password  char(50)   not null);'''

    # '''TABLE POINT (
    #   ID        serial     NOT NULL PRIMARY KEY ,
    #   USER_ID   INT        NOT NULL REFERENCES USER_INFO (ID),
    #   TIME      TIMESTAMP  NOT NULL default now(),
    #   COORD_X   REAL       NOT NULL,
    #   COORD_Y   REAL       NOT NULL);'''

    # '''TABLE timer (
    #   USER_ID   INT        NOT NULL REFERENCES USER_INFO (ID),
    #   END_TIME  TIMESTAMP  NOT NULL,
    #   TYPE      CHAR(15)   NOT NULL);'''

    connection = None
    cursor = None

    def __init__(self):  # connect
        self.connection = psycopg2.connect(database=DATABASE_TYPE,
                                           user=USER_NAME,
                                           password=USER_PASSWORD,
                                           host=HOST,
                                           port=PORT)
        self.cursor = self.connection.cursor()
        print("DB opened successfully", flush=True)

    def __del__(self):
        if self.connection:
            self.connection.close()
            print("DB closed successfully", flush=True)


    def authorisation(self, user_id, password):
        return True


    # geo-tags
    def add_point(self, user_id, coords):
        coord_x, coord_y = coords
        response = None
        try:
            self.cursor.execute(f'''insert into point 
            (user_id, coord_x, coord_y) values 
            ({user_id}, {coord_x}, {coord_y});''')
            self.connection.commit()
            print("Point successfully added to DB", flush=True)
            response = "Point successfully added"
        except (Exception, psycopg2.Error) as error:
            print("Error while connecting to PostgreSQL", error, flush=True)
            response = f"Error while connecting to PostgreSQL {error}"
        finally:
            return response

    def get_points(self, user_id, time='2 days'):
        ''' def get_points(self, user_id, time=None):
            user_id - just number
            time in format like "6 years 5 months 4 days 3 hours 2 minutes 1 second"
        '''
        response = None
        try:
            self.cursor.execute(f'''select to_char(time, 'YYYY/MM/DD hh:mm:ss'), coord_x, coord_y 
            from point where 
            user_id={user_id} and 
            time >= now()- interval '{time}'
            order by time desc;''')
            response = self.cursor.fetchall()
        except (Exception, psycopg2.Error) as error:
            print("Error while connecting to PostgreSQL", error, flush=True)
            response = f"Error while connecting to PostgreSQL {error}"
        finally:
            return response

    # timers
    def add_timer(self, user_id, end_time, alarm_type="pre-alarm"):
        response = None
        try:
            self.cursor.execute(f'''insert into timer (user_id, end_time, type) values 
            ({user_id}, now() + interval '{end_time}', '{alarm_type}'); ''')
            self.connection.commit()
            response = "Timer successfully added"
        except (Exception, psycopg2.Error) as error:
            print("Error while connecting to PostgreSQL", error, flush=True)
            response = f"Error while connecting to PostgreSQL {error}"
        finally:
            return response


    def get_timers_by_time(self, time_activation='2 hours'):
        response = None
        try:
            self.cursor.execute(f'''select user_id, end_time-now(), type
                    from timer where 
                    end_time <= now() + interval '{time_activation}'
                    order by end_time;''')
            response = self.cursor.fetchall()
            help = []
            for i in range(len(response)):
                help.append((response[i][0], str(response[i][1]), response[i][2]))
            response = help
        except (Exception, psycopg2.Error) as error:
            print("Error while connecting to PostgreSQL", error, flush=True)
            response = f"Error while connecting to PostgreSQL {error}"
        finally:
            return response

    def del_timer(self, user_id):
        response = None
        try:
            self.cursor.execute(f''' delete from timer where user_id={user_id};''')
            self.connection.commit()
            response = "Timer successfully deleted"
        except (Exception, psycopg2.Error) as error:
            print("Error while connecting to PostgreSQL", error, flush=True)
            response = f"Error while connecting to PostgreSQL {error}"
        finally:
            return response
        pass




db = Database()
