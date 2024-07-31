from google.cloud import bigquery
import pandas as pd

# Configurar el cliente de BigQuery
client = bigquery.Client()

# Cargar datos desde un archivo CSV
df = pd.read_csv('./Netflix_limpio.csv', encoding='latin-1')

# Definir el ID del proyecto y la tabla de destino
project_id = 'mariano-gobea'
dataset_id = 'Mariano_Gobea_MELI'
table_id = 'Netflix'
dataset_ref = f"{project_id}.{dataset_id}"
table_ref = f"{dataset_ref}.{table_id}"

# Crear el dataset si no existe
try:
    client.get_dataset(dataset_ref)  # Intentar obtener el dataset
    print(f"Dataset {dataset_id} ya existe.")
except:
    # Si el dataset no existe, crearlo
    dataset = bigquery.Dataset(dataset_ref)
    dataset.location = "US"  # Puedes especificar la ubicación del dataset
    dataset = client.create_dataset(dataset, timeout=30)
    print(f"Dataset {dataset_id} creado exitosamente.")

# Crear la tabla si no existe
schema = [
    bigquery.SchemaField("show_id", "STRING"),
    bigquery.SchemaField("type", "STRING"),
    bigquery.SchemaField("title", "STRING"),
    bigquery.SchemaField("director", "STRING"),
    bigquery.SchemaField("cast", "STRING"),
    bigquery.SchemaField("country", "STRING"),
    bigquery.SchemaField("date_added", "DATETIME"),
    bigquery.SchemaField("release_year", "INTEGER"),
    bigquery.SchemaField("rating", "STRING"),
    bigquery.SchemaField("duration", "STRING"),
    bigquery.SchemaField("listed_in", "STRING"),
    bigquery.SchemaField("description", "STRING")
]

try:
    client.get_table(table_ref)  # Intentar obtener la tabla
    print(f"Tabla {table_id} ya existe.")
except:
    # Si la tabla no existe, crearla
    table = bigquery.Table(table_ref, schema=schema)
    table = client.create_table(table)
    print(f"Tabla {table_id} creada exitosamente.")

# Enviar el DataFrame a BigQuery
job = client.load_table_from_dataframe(df, table_ref)
job.result()  # Esperar a que el trabajo termine

print("Datos cargados exitosamente en BigQuery")
