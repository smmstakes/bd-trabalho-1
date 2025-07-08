from datetime import date
from database.connection import connect_db

class Candidatura:
    def __init__(self, cpf_aluno, id_vaga, status, arquivo_curriculo, dt_candidatura=date.today()):
        self.cpf_aluno = cpf_aluno
        self.id_vaga = id_vaga
        self.status = status
        self.dt_candidatura = dt_candidatura
        self.arquivo_curriculo = arquivo_curriculo 

    def __exists(self):
        conn = None
        try:
            conn = connect_db()
            cursor = conn.cursor()

            cursor.execute("SELECT status_candidatura FROM candidatura WHERE id_vaga = %s AND cpf = %s",
                            (self.id_vaga, self.cpf_aluno,))
            exists = cursor.fetchone()
            return exists

        except Exception as e:
            print(f"Erro ao verificar existência da Candidatura: {e}")
            return False

        finally:
            if conn:
                cursor.close()
                conn.close()
    
    def create(self):
        conn = None
        try:
            conn = connect_db()
            cursor = conn.cursor()

            existe_candidatura = self.__exists()
            if existe_candidatura:
                print(f"Erro: O aluno {self.cpf_aluno} já se candidatou para a vaga {self.id_vaga}.")
                return

            sql = """
            INSERT INTO CANDIDATURA (CPF, ID_VAGA, STATUS_CANDIDATURA, DT_CANDIDATURA, ARQUIVO_CURRICULO)
            VALUES (%s, %s, %s, %s, %s);
            """

            cursor.execute(sql, (self.cpf_aluno, self.id_vaga, self.status, self.dt_candidatura, self.arquivo_curriculo))
            
            conn.commit()

            print(f"Candidatura do aluno {self.cpf_aluno} para a vaga {self.id_vaga} realizada com sucesso.")

        except Exception as e:
            print(f"Erro ao criar candidatura: {e}")
            if conn:
                conn.rollback()

        finally:
            if conn:
                cursor.close()
                conn.close()

    def update_status(self, novo_status):
        conn = None

        try:
            conn = connect_db()
            cursor = conn.cursor()

            existe_candidatura = self.__exists()
            if not existe_candidatura:
                print(f"Erro: Não existe candidatura para o aluno {self.cpf_aluno} na vaga {self.id_vaga}.")
                return

            sql = """UPDATE CANDIDATURA SET STATUS_CANDIDATURA = %s WHERE CPF = %s AND ID_VAGA = %s;"""
            cursor.execute(sql, (novo_status, self.cpf_aluno, self.id_vaga))
            
            conn.commit()

            self.status = novo_status
            print(f"Status da candidatura ({self.cpf_aluno}, {self.id_vaga}) atualizado para '{self.status}'.")

        except Exception as e:
            print(f"Erro ao atualizar status da candidatura: {e}")
            if conn:
                conn.rollback()

        finally:
            if conn:
                cursor.close()
                conn.close()

    def delete(self):
        conn = None

        try:
            conn = connect_db()
            cursor = conn.cursor()

            cursor.execute("DELETE FROM CANDIDATURA WHERE CPF = %s AND ID_VAGA = %s", 
                           (self.cpf_aluno, self.id_vaga))
            
            if cursor.rowcount == 0:
                print(f"Aviso: Nenhuma candidatura encontrada para o aluno {self.cpf_aluno} na vaga {self.id_vaga}.")
            else:
                print(f"Candidatura ({self.cpf_aluno}, {self.id_vaga}) removida com sucesso.")

            conn.commit()

        except Exception as e:
            print(f"Erro ao remover candidatura: {e}")
            if conn:
                conn.rollback()

        finally:
            if conn:
                cursor.close()
                conn.close()

    @classmethod
    def get_by_vaga(cls, id_vaga):
        candidatos = []
        conn = None

        try:
            conn = connect_db()
            cursor = conn.cursor()

            # Consulta para pegar as candidaturas de uma determinada vaga
            sql = """
                SELECT p.NOME, p.EMAIL, c.STATUS_CANDIDATURA, c.DT_CANDIDATURA
                FROM CANDIDATURA c
                JOIN ALUNO a ON c.CPF = a.CPF
                JOIN PESSOA p ON a.CPF = p.CPF
                WHERE c.ID_VAGA = %s
                ORDER BY c.DT_CANDIDATURA DESC;
                """
            
            cursor.execute(sql, (id_vaga,))
            candidatos = cursor.fetchall()

        except Exception as e:
            print(f"Erro ao buscar candidatos por vaga: {e}")

        finally:
            if conn:
                cursor.close()
                conn.close()

        return candidatos
    
    @classmethod
    def get_by_aluno(cls, cpf_aluno):
        candidaturas = []
        conn = None

        try:
            conn = connect_db()
            cursor = conn.cursor()

            # Consulta para pegar todas as vagas de um aluno, pelo CPF
            sql = """
                SELECT v.TITULO, v.ID, c.STATUS_CANDIDATURA, c.DT_CANDIDATURA
                FROM CANDIDATURA c
                JOIN VAGA v ON c.ID_VAGA = v.ID
                WHERE c.CPF = %s
                ORDER BY c.DT_CANDIDATURA DESC;
                """
            
            cursor.execute(sql, (cpf_aluno,))

            candidaturas = cursor.fetchall()

        except Exception as e:
            print(f"Erro ao buscar candidaturas por aluno: {e}")

        finally:
            if conn:
                cursor.close()
                conn.close()

        return candidaturas
