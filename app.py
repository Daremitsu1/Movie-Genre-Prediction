import streamlit as st
import rpy2.robjects as robjects

# Load the R model
r = robjects.r
r['load']('movie_model.rds')

# Define function to get user input
def get_user_input():
    age = st.sidebar.slider('Age', 1, 100, 25)
    gender = st.sidebar.selectbox('Gender', ('Male', 'Female', 'Other'))
    occupation = st.sidebar.selectbox('Occupation', ('Student', 'Engineer', 'Artist', 'Other'))
    return {'age': age, 'gender': gender, 'occupation': occupation}

# Define function to make prediction
def predict_genre(model, user_input):
    # Convert user input to R dataframe
    r_input = r['data.frame'](age=user_input['age'],
                              gender=user_input['gender'],
                              occupation=user_input['occupation'])
    # Make prediction with R model
    pred = r['predict'](model, r_input)
    # Convert R output to Python object and return predicted genre
    return robjects.vectors.FactorVector(pred)[0]

# Define app
def main():
    # Set app title
    st.title('Movie Genre Predictor')
    # Get user input
    user_input = get_user_input()
    # Make prediction
    genre = predict_genre(r['model'], user_input)
    # Display prediction
    st.subheader('Predicted Genre:')
    st.write(genre)

if __name__ == '__main__':
    main()
