from pymongo import MongoClient
import bson

client = MongoClient('mongodb://qaninja:qaninja123@ds035664.mlab.com:35664/spotdb?retryWrites=false&w=majority')
db = client['spotdb']

def hard_reset(user_id):
    spots().delete_many({'user': bson.objectid.ObjectId(user_id)})

def remove_spot_by_company(company):
    spots().delete_many({'company': company})

def insert_unique_spot(spot):
    remove_spot_by_company(spot.company)
    return spots().insert_one(spot).inserted_id

def get_mongo_id():
    return bson.objectid.ObjectId()

def spots():
    return db['spots']
