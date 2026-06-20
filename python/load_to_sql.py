import pandas as pd
from sqlalchemy import create_engine

server = 'DESKTOP-TQ0SKDR\\SQLEXPRESS'
database = 'ChurnDB'

connection_string = f"mssql+pyodbc://@{server}/{database}?driver=ODBC+Driver+18+for+SQL+Server&trusted_connection=yes&TrustServerCertificate=yes"

engine = create_engine(connection_string)

raw_path = 'data/raw/'

# Load all 6 raw files
files = {
    'stg_demographics' : 'Telco_customer_churn_demographics.csv',
    'stg_location'     : 'Telco_customer_churn_location.csv',
    'stg_services'     : 'Telco_customer_churn_services.csv',
    'stg_status'       : 'Telco_customer_churn_status.csv',
    'stg_population'   : 'Telco_customer_churn_population.csv',
    'stg_main'         : 'CustomerChurn.csv'
}

for table_name, file_name in files.items():
    df = pd.read_csv(raw_path + file_name)
    df.to_sql(table_name, con=engine, if_exists='replace', index=False)
    print(f"Loaded {file_name} → {table_name} ({df.shape[0]} rows, {df.shape[1]} columns)")

print("\nAll 6 raw files loaded successfully!")
