from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
import joblib
import numpy as np
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import os

# Fix the NameError by using _file_ instead of file
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_DIR = os.path.abspath(os.path.join(CURRENT_DIR, "../linear_regression/saved_models"))

MODEL_PATH = os.path.join(MODEL_DIR, "best_model.pkl")
SCALER_PATH = os.path.join(MODEL_DIR, "scaler.pkl")

# Debugging: Print paths and available files
print("\nChecking model and scaler paths...")
print(f"MODEL_PATH: {MODEL_PATH} - Exists: {os.path.exists(MODEL_PATH)}")
print(f"SCALER_PATH: {SCALER_PATH} - Exists: {os.path.exists(SCALER_PATH)}")

if os.path.exists(MODEL_DIR):
    print("\nFiles in MODEL_DIR:", os.listdir(MODEL_DIR))
else:
    print("\nMODEL_DIR does not exist.")

# Initialize model and scaler
model, scaler = None, None

try:
    if os.path.exists(MODEL_PATH) and os.path.exists(SCALER_PATH):
        print("\nLoading model and scaler...")
        model = joblib.load(MODEL_PATH)
        scaler = joblib.load(SCALER_PATH)
        print("Model and scaler loaded successfully.")
    else:
        raise FileNotFoundError("Model or scaler file not found. Check file paths above.")
except Exception as e:
    print(f"\nError loading model or scaler: {e}")
    model, scaler = None, None  # Ensure API doesn't crash

# Define FastAPI app
app = FastAPI(title="Career Success Prediction API")

# Enable CORS for frontend/backend communication
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Change this to restrict access
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Root endpoint to prevent 404 errors
@app.get("/")
def home():
    return {"message": "Welcome to the Career Success Prediction API!"}

# Define request model with constraints
class PredictionRequest(BaseModel):
    features: list[float] = Field(..., min_items=10, max_items=10)  # Adjust based on actual feature count

@app.post("/predict")
def predict(request: PredictionRequest):
    if model is None or scaler is None:
        raise HTTPException(status_code=500, detail="Model or scaler is not loaded. Deployment issue detected. Check logs for details.")
    
    try:
        # Convert input data to numpy array
        input_data = np.array(request.features).reshape(1, -1)
        
        # Scale input data
        input_scaled = scaler.transform(input_data)
        
        # Make prediction
        prediction = model.predict(input_scaled)
        
        return {"predicted_career_success": float(prediction[0])}
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Prediction error: {e}")

if __name__ == "__main__":  
    uvicorn.run(app, host="127.0.0.1", port=8000, reload=True)
