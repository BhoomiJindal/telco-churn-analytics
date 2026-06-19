import pandas as pd
from sqlalchemy import create_engine

csv_path = 'data/cleaned_churn_data.csv'
df = pd.read_csv(csv_path)

print(f"Loaded {df.shape[0]} rows and {df.shape[1]} columns from CSV")
print(df.dtypes)

server = 'DESKTOP-TQ0SKDR\\SQLEXPRESS'
database = 'ChurnDB'

connection_string = f"mssql+pyodbc://@{server}/{database}?driver=ODBC+Driver+18+for+SQL+Server&trusted_connection=yes&TrustServerCertificate=yes"

engine = create_engine(connection_string)

df.to_sql('stg_churn_v2', con=engine, if_exists='replace', index=False)

print("Data pushed to stg_churn_v2 successfully!")