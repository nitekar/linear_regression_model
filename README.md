# Career Success Prediction

## Project Overview
Predict **Career success** based on  education data using machine learning models (Linear Regression, Decision Tree, Random Forest). The project includes:
1. **Modeling:** Building and comparing models to find the best performer.
2. **API Deployment:** FastAPI for prediction using the best model.
3. **Mobile App:** Flutter app for user input and prediction.
4. **Video Demo:** Showing the app and API in action.

---

## Dataset
The dataset contains career and education metrics, including:
- **Personal Info:** Age, Gender, Student_ID
- **Education Metrics:** High School GPA, SAT Score, University GPA
- **Career Metrics:** Job Offers, Starting Salary, Career Satisfaction
- **Skill Scores:** Soft Skills, Networking, Internships

Source: [Kaggle](https://www.kaggle.com/)

---

## Modeling
1. **Data Preprocessing:** Cleaning, encoding, and splitting data.
2. **Models:**
   - **Linear Regression (Gradient Descent)**
   - **Decision Tree**
   - **Random Forest**
3. **Evaluation:** Mean Squared Error (MSE) and R² score.
4. **Model Selection:** Best-performing model (Random Forest) saved as `best_model.pkl`.

---

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/career-success-prediction.git
   cd summative
---

## API Deployment
- **Framework:** FastAPI
- **Input:** JSON with career and education metrics
- **Output:** Career sucess Prediction
- **Public URL:** https://linear-regression-model-m6bj.onrender.com/docs
---
**API install**
cd ../API 
pip install -r requirements.txt 
python -m uvicorn prediction:app --host 127.0.0.1 --port 8000 --reload
---
Flutter App

flutter pub get
flutter run

##Demo video https://youtu.be/Jk90KCtsPaI
  
