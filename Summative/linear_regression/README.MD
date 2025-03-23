# Career Success Prediction & Work-Life Balance API

## Project Overview

This project aims to predict **Work-Life Balance** for individuals based on various education and career-related features. The project consists of three major tasks:

1. **Modeling:** Building and comparing multiple regression models (Linear Regression, Decision Tree, Random Forest) on a career success dataset to predict work-life balance.

2. **API Deployment:** Creating a FastAPI-based REST API that returns predictions based on input values. The API is deployed on a publicly available URL and is accessible through Swagger UI.
3. **Mobile App:** Developing a Flutter mobile app that connects to the API to allow users to input values and receive predictions in real time.
4. **Video Demo:** A short video demo (max 3 minutes) showcasing the mobile app predictions and the API using Swagger UI, along with a discussion on model performance.

## Dataset

The dataset used in this project, `education_career_success.csv`, includes 5000 entries with 20 features. It contains information such as:

- **Student Information:** Age, Gender, Student_ID.
- **Academic Performance:** High_School_GPA, SAT_Score, University_Ranking, University_GPA.
- **Extracurriculars & Skills:** Internships Completed, Projects Completed, Certifications, Soft Skills Score, Networking Score.
- **Career Metrics:** Job Offers, Starting Salary, Career Satisfaction, Years to Promotion, Current Job Level, Work-Life Balance, Entrepreneurship.

The dataset is sourced from [Kaggle](https://www.kaggle.com/) and has been preprocessed in our Kaggle notebook.

## Modeling Process

1. **Data Preprocessing:**  
   - Handling missing values and encoding categorical variables.
   - Splitting the dataset into training and testing sets.
   - Feature selection based on correlation analysis.

2. **Model Training & Evaluation:**  
   - **Linear Regression:** Optimized using gradient descent.
   - **Decision Tree Regressor**
   - **Random Forest Regressor**
   - Evaluation is done using the Mean Squared Error (MSE) and R² metrics.
   - The model with the lowest MSE (in this case, Random Forest) is saved as `best_model.pkl`.

3. **Visualization:**  
   - A correlation heatmap and histograms for variable distributions.
   - A scatter plot comparing actual vs. predicted work-life balance values.

## API Endpoint (Task 2)

The API is built using FastAPI and exposes a single prediction endpoint. Key features include:

- **Endpoint:** `POST /predict`

- **Request Body:** JSON object with the necessary input features.
- **Response:** JSON with the predicted Work-Life Balance.
- **Data Validation:** Implemented using Pydantic to enforce data types and acceptable ranges.
- **CORS Middleware:** Enabled to allow cross-origin requests.

**Publicly Available API URL:**  
[https://myapi.example.com/docs](https://myapi.example.com/docs)  
*(Replace with your actual deployment URL. The Swagger UI documentation is available at the `/docs` endpoint.)*

## Mobile App (Flutter)

- Input Fields: Correspond to model features.

- Button: "Predict" to trigger the API call.

- Output: Predicted balance or error message.
