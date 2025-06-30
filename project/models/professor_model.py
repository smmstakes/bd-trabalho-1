from database.connection import connect_db

class Professor:
    def __init__(self, cpf, nome, matricula, email, departamento=None):
        self.cpf = cpf
        self.nome = nome
        self.matricula = matricula
        self.email = email
        self.departamento = departamento
    
    @classmethod
    def get_all(cls):
        professores = []
        conn = connect_db()

        if not conn:
            return professores
        
        try:
            cursor = conn.cursor()

            # Consula para pegar as informações do professor
            sql = """
                SELECT P.CPF, PE.nome, PE.matricula, PE.email, D.nome
                FROM PROFESSOR P
                JOIN PESSOA PE ON P.CPF = PE.CPF
                JOIN DEPARTAMENTO D ON P.ID_DEPARTAMENTO = D.ID
                ORDER BY PE.NOME
                """

            cursor.execute(sql)

            for row in cursor.fetchall():
                professores.append(cls(cpf=row[0], nome=row[1], matricula=row[2],
                                       email=row[3], departamento=row[4]))

        finally:
            if conn:
                cursor.close()
                conn.close()

        return professores
    