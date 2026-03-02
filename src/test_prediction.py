import joblib
import pandas as pd

# 1. Load the model you just trained
model = joblib.load('model.joblib')

# 2. Create a dummy "Iris" record (matching the BigQuery schema)
# features: sepal_length, sepal_width, petal_length, petal_width
test_data = pd.DataFrame([[5.1, 3.5, 1.4, 0.2]], 
                         columns=['sepal_length', 'sepal_width', 'petal_length', 'petal_width'])

# 3. Predict!
prediction = model.predict(test_data)
print(f"✅ Prediction Result: {prediction[0]}")