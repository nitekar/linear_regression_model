from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
import joblib
import numpy as np
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import os

# Load the saved model and scaler
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_DIR = os.path.join(CURRENT_DIR, "../linear_regression")

MODEL_PATH = os.path.join(MODEL_DIR, "saved_models/best_model.pkl")
SCALER_PATH = os.path.join(MODEL_DIR, "saved_models/scaler.pkl")

try:
    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)
except Exception as e:
    raise RuntimeError(f"Error loading model or scaler: {e}")

# Define FastAPI app
app = FastAPI(title="Work-Life Balance Prediction API")

# Enable CORS for frontend/backend communication
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Change this to restrict access
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define request model with constraints
class PredictionRequest(BaseModel):
    features: list[float] = Field(..., min_items=10, max_items=10)  # Adjust based on actual feature count

@app.post("/predict")
def predict(request: PredictionRequest):
    try:
        # Convert input data to numpy array
        input_data = np.array(request.features).reshape(1, -1)
        
        # Scale input data
        input_scaled = scaler.transform(input_data)
        
        # Make prediction
        prediction = model.predict(input_scaled)
        
        return {"predicted_work_life_balance": float(prediction[0])}
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Prediction error: {e}")

if __name__ == "__main__":  
    uvicorn.run(app, host="0.0.0.0", port=8000)