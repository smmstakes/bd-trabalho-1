import psycopg2

from psycopg2 import OperationalError

def connect_db():
    """
    Estabelece a conexão com o banco de dados PostgreSQL.
    """
    try:
        conn = psycopg2.connect(
            dbname="bd_catalogo_vagas",
            user="admin_catalogo_vagas",
            password="adminpsswrd1234",
            host="localhost",
            port="5432"
        )
        return conn
    
    except OperationalError as e:
        print(f"Erro ao conectar ao banco de dados: {e}")
        return None

# --- Bloco de teste ---
if __name__ == '__main__':
    conn = connect_db()
    if conn:
        conn.close()

