from database.connection import connect_db

class Curso:
    def __init__(self, id, nome):
        self.id = id
        self.nome = nome

    @classmethod
    def get_all(cls):
        """Busca todos os cursos do banco de dados."""

        cursos = []
        conn = None

        try:
            conn = connect_db()
            cursor = conn.cursor()

            cursor.execute("SELECT ID, NOME FROM CURSO ORDER BY ID")

            for row in cursor.fetchall():
                cursos.append(cls(id=row[0], nome=row[1]))

        except Exception as e:
            print(f"Erro ao listar cursos: {e}")

        finally:
            if conn:
                cursor.close()
                conn.close()
                
        return cursos
    