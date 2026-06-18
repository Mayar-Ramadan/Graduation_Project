from fastapi import FastAPI
from catboost import CatBoostRegressor, Pool

app = FastAPI()

model = CatBoostRegressor()
model.load_model("CatBoost_WaterConsumption.cbm")

@app.get("/")
def home():
    return {"message": "API working"}

@app.post("/predict")
def predict(data: dict):
    try:
        features = data["features"]

        # features لازم تكون بالشكل ده:
        # [22, "female", 30, "medium"]

        pool = Pool(
            data=[features],
            cat_features=[1, 3]
        )

        prediction = model.predict(pool)

        return {"prediction": float(prediction[0])}

    except Exception as e:
        return {"error": str(e)}


