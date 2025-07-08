# Arquivo: models/aluno_model.py (versão com create e update)

from database.connection import connect_db

class Aluno:
    def __init__(self, cpf, matricula, nome, email, cep, complemento_end, numero_end, url_lattes=None, semestre=None, id_curso=None, nome_curso=None):
        self.cpf = cpf
        self.matricula = matricula
        self.nome = nome
        self.email = email
        self.cep = cep
        self.complemento_end = complemento_end
        self.numero_end = numero_end
        self.url_lattes = url_lattes
        self.semestre = semestre
        self.id_curso = id_curso
        self.nome_curso = nome_curso

    def create(self):
        conn = None
        try:
            conn = connect_db()
            cursor = conn.cursor()

            sql_pessoa = """
            INSERT INTO PESSOA (CPF, MATRICULA, NOME, EMAIL, CEP_END, COMPLEMENTO_END, NUMERO_END) 
            VALUES (%s, %s, %s, %s, %s, %s, %s)"""
            cursor.execute(sql_pessoa, (self.cpf, self.matricula, self.nome, self.email, 
                                        self.cep, self.complemento_end, self.numero_end))
            
            sql_aluno = """INSERT INTO ALUNO (CPF, URL_LATTES, SEMESTRE, ID_CURSO) 
            VALUES (%s, %s, %s, %s)"""
            cursor.execute(sql_aluno, (self.cpf, self.url_lattes, self.semestre, self.id_curso))

            conn.commit()

            print(f"Aluno {self.nome} (CPF: {self.cpf}) criado com sucesso!")

        except Exception as e:
            if conn:
                conn.rollback()

            if 'violates unique constraint' in str(e):
                print(f"Erro: CPF ou Matrícula já cadastrado no sistema.")
            elif "is not present in table" in str(e):
                print(f"Erro: ID escolhido não corresponde a nenhum curso do sistema.")
            else:
                print(f"Erro ao criar aluno: {e}")

        finally:
            if conn:
                cursor.close()
                conn.close()

    def update(self):
        conn = None
        try:
            conn = connect_db()
            cursor = conn.cursor()

            sql_pessoa = """UPDATE PESSOA SET NOME = %s, EMAIL = %s, MATRICULA = %s WHERE CPF = %s"""
            cursor.execute(sql_pessoa, (self.nome, self.email, self.matricula, self.cpf))
            
            sql_aluno = """UPDATE ALUNO SET SEMESTRE = %s, URL_LATTES = %s, ID_CURSO = %s WHERE CPF = %s"""
            cursor.execute(sql_aluno, (self.semestre, self.url_lattes, self.id_curso, self.cpf))
            
            # Verifica se alguma linha foi atualizada
            if cursor.rowcount == 0:
                print(f"[bold yellow]Aviso: Nenhum aluno encontrado com o CPF {self.cpf}, nada foi atualizado.[/bold yellow]")
            else:
                print(f"Aluno {self.nome} (CPF: {self.cpf}) atualizado com sucesso!")
            
            conn.commit()

        except Exception as e:
            if conn:
                conn.rollback()

            print(f"Erro ao atualizar aluno: {e}")

        finally:
            if conn:
                cursor.close()
                conn.close()

    def delete(self):
        conn = None
        try:
            conn = connect_db()
            cursor = conn.cursor()

            cursor.execute("DELETE FROM PESSOA WHERE CPF = %s", (self.cpf,))
            
            if cursor.rowcount == 0:
                print(f"Aviso: Nenhum aluno encontrado com o CPF {self.cpf}, nada foi removido.")
            else:
                print(f"Aluno com CPF {self.cpf} e todos os seus dados associados foram removidos com sucesso!")

            conn.commit()

        except Exception as e:
            if conn:
                conn.rollback()
            print(f"Erro ao remover aluno: {e}")

        finally:
            if conn:
                cursor.close()
                conn.close()

    @classmethod
    def get_by_cpf(cls, cpf):
        conn = None
        aluno_obj = None

        try:
            conn = connect_db()
            cursor = conn.cursor()

            # Consulta para pegar as informações do aluno e o nome do curso
            sql = """
            SELECT p.CPF, p.MATRICULA, p.NOME, p.EMAIL, p.CEP_END, p.COMPLEMENTO_END, p.NUMERO_END,
                   a.URL_LATTES, a.SEMESTRE, a.ID_CURSO, c.NOME AS CURSO_NOME
            FROM PESSOA p
            JOIN ALUNO a ON p.CPF = a.CPF
            JOIN CURSO c ON a.ID_CURSO = c.ID
            WHERE p.CPF = %s
            """

            cursor.execute(sql, (cpf,))

            row = cursor.fetchone()
            if row:
                aluno_obj = cls(cpf=row[0], matricula=row[1], nome=row[2], email=row[3], cep=row[4], 
                                complemento_end=row[5], numero_end=row[6], url_lattes=row[7], 
                                semestre=row[8], id_curso=row[9], nome_curso=row[10])
                
        except Exception as e:
            print(f"Erro ao buscar aluno por CPF: {e}")

        finally:
            if conn:
                cursor.close()
                conn.close()

        return aluno_obj
    
    @classmethod
    def get_by_matricula(cls, matricula):
        conn = None

        try:
            conn = connect_db()
            cursor = conn.cursor()

            sql = """
            SELECT p.CPF FROM PESSOA p WHERE p.MATRICULA = %s
            """

            cursor.execute(sql, (matricula,))

            row = cursor.fetchone()
            if row:
                return True
            
        except Exception as e:
            print(f"Erro ao buscar aluno por matrícula: {e}")

        finally:
            if conn:
                cursor.close()
                conn.close()

        return False

    @classmethod
    def get_all(cls):
        alunos_obj = []
        conn = None

        try:
            conn = connect_db()
            cursor = conn.cursor()

            #  Consulta para pegar todos os alunos cadastrados no sistema
            sql = """
            SELECT p.CPF, p.MATRICULA, p.NOME, p.EMAIL, p.CEP_END, p.COMPLEMENTO_END, p.NUMERO_END,
                   a.URL_LATTES, a.SEMESTRE, a.ID_CURSO, c.NOME AS CURSO_NOME
            FROM PESSOA p
            JOIN ALUNO a ON p.CPF = a.CPF
            JOIN CURSO c ON a.ID_CURSO = c.ID
            ORDER BY p.NOME;
            """

            cursor.execute(sql)

            for row in cursor.fetchall():
                alunos_obj.append(cls(cpf=row[0], matricula=row[1], nome=row[2], email=row[3], cep=row[4], 
                                      complemento_end=row[5], numero_end=row[6], url_lattes=row[7], 
                                      semestre=row[8], id_curso=row[9], nome_curso=row[10]))
                
        except Exception as e:
            print(f"Erro ao listar alunos: {e}")

        finally:
            if conn:
                cursor.close()
                conn.close()

        return alunos_obj
