import pandas as pd
from pymongo import MongoClient

# Cargar CSVs
clientes_df = pd.read_csv("Malla_Vial_Integral_Bogota_D_C.csv")
ventas_df = pd.read_csv("Velocidades_Bitcarrier_Octubre_2022_-6127288799100833382.csv")

# Conexión a MongoDB (puerto 27017 por defecto)
client = MongoClient("mongodb://localhost:27017/")

# Seleccionar base de datos
db = client["mi_base_de_datos"]

# Insertar en colecciones
db["clientes"].insert_many(clientes_df.to_dict("records"))
db["ventas"].insert_many(ventas_df.to_dict("records"))

print("Importación completa.")