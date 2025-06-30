from database.connection import connect_db

class Tipo:
    def __init__(self, id, nome):
        self.id = id
        self.nome = nome

    @classmethod
    def get_all(cls):
        tipos = []
        conn = connect_db()

        if not conn:
            return tipos
        
        try:
            cursor = conn.cursor()

            cursor.execute("SELECT id, nome FROM Tipo ORDER BY id")

            for row in cursor.fetchall():
                tipos.append(cls(id=row[0], nome=row[1]))

        except Exception as e:
            print(f"Erro ao buscar tipos: {e}")

        finally:
            if conn:
                cursor.close()
                conn.close()
                
        return tipos
