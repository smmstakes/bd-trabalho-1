from datetime import date
from database.connection import connect_db

class Vaga:
    def __init__(self, titulo, descricao, carga_horaria, id_tipo, id=None, 
                 data_publicacao=date.today(), data_fim=None, cnpj=None, 
                 cpf=None, nome_tipo=None, nome_empresa=None, nome_professor=None):
        self.id = id
        self.titulo = titulo
        self.descricao = descricao
        self.data_publicacao = data_publicacao
        self.data_fim = data_fim
        self.carga_horaria = carga_horaria
        self.cnpj = cnpj
        self.cpf = cpf
        self.id_tipo = id_tipo

        self.nome_tipo = nome_tipo
        self.nome_empresa = nome_empresa
        self.nome_professor = nome_professor

    def __exists(self):
        conn = None
        try:
            conn = connect_db()
            cursor = conn.cursor()

            cursor.execute("SELECT id FROM vaga WHERE id = %s", (self.id,))
            exists = cursor.fetchone()

            return exists
        
        except Exception as e:
            print(f"Erro ao verificar existência da Vaga: {e}")
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

            existe_vaga = self.__exists()
            if existe_vaga:
                print(f"Vaga com ID {self.id} já existe.")
                return False

            sql = """
            INSERT INTO vaga (titulo, descricao, data_publicacao, data_fim, carga_horaria, cnpj, cpf, id_tipo) 
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            RETURNING id"""

            cursor.execute(sql, (self.titulo, self.descricao, self.data_publicacao,
                                        self.data_fim, self.carga_horaria,
                                        self.cnpj, self.cpf, self.id_tipo))
            
            self.id = cursor.fetchone()[0]  # Obtém o ID da vaga recém-criada

            conn.commit()

            print(f"Vaga {self.titulo} (ID: {self.id}) criada com sucesso!")
        
        except Exception as e:
            if conn:
                conn.rollback()

            print(f"Erro ao criar Vaga: {e}")

        finally:
            if conn:
                cursor.close()
                conn.close()

    def update(self):
        conn = None

        try:
            conn = connect_db()
            cursor = conn.cursor()

            existe_vaga = self.__exists()
            if not existe_vaga:
                print("Vaga não encontrada.")
                return False

            sql = """
            UPDATE vaga SET 
            titulo = %s, descricao = %s, data_fim = %s, carga_horaria = %s, 
            cnpj = %s, cpf = %s, id_tipo = %s 
            WHERE id = %s
            """

            cursor.execute(sql, (self.titulo, self.descricao, self.data_fim, self.carga_horaria, self.cnpj, self.cpf, self.id_tipo, self.id))

            conn.commit()

            print(f"Vaga {self.titulo} (ID: {self.id}) atualizada com sucesso!")

        except Exception as e:
            if conn:
                conn.rollback()

            print(f"Erro ao atualizar Vaga: {e}")

        finally:
            if conn:
                cursor.close()
                conn.close()

    def delete(self):
        conn = None

        try:
            conn = connect_db()
            cursor = conn.cursor()

            existe_vaga = self.__exists()
            if not existe_vaga:
                print("Vaga não encontrada.")
                return 

            cursor.execute("DELETE FROM AREA_VAGA WHERE ID_VAGA = %s", (self.id,))
            cursor.execute("DELETE FROM CANDIDATURA WHERE ID_VAGA = %s", (self.id,))
        
            cursor.execute("DELETE FROM VAGA WHERE id = %s", (self.id,))
            
            conn.commit()

            print(f"Vaga ID {self.id} e todas as suas dependências foram removidas com sucesso.")


        except Exception as e:
            if conn:
                conn.rollback()
            
            if "is still referenced from table" in str(e):
                print(f"Erro ao deletar a Vaga: Não é possível deletar a vaga pois há candidaturas",
                      "associadas a esta vaga.\n")
                
            print(f"Erro ao deletar Vaga: {e}")

        finally:
            if conn:
                cursor.close()
                conn.close()

    @classmethod 
    def get_all(cls):
        """
        Busca todas as vagas e retorna uma lista de objetos Vaga.
        Usa LEFT JOIN para buscar o nome da empresa ou do professor, já que um deles pode ser nulo.
        """

        vagas_obj = []
        conn = None

        try:
            conn = connect_db()
            cursor = conn.cursor()

            # Consulta para pegar todas as vagas, podem ser de empresas ou de professores
            sql = """
                SELECT v.id, v.titulo, v.descricao, v.data_publicacao, v.data_fim, v.carga_horaria,
                    t.nome as nome_tipo,
                    e.nome_fantasia as nome_empresa,
                    p.nome as nome_professor,
                    v.cnpj, v.cpf, v.id_tipo
                FROM VAGA v
                JOIN TIPO t ON v.id_tipo = t.id
                LEFT JOIN EMPRESA e ON v.cnpj = e.cnpj
                LEFT JOIN PROFESSOR prof ON v.cpf = prof.cpf
                LEFT JOIN PESSOA p ON prof.cpf = p.cpf
                ORDER BY v.id ASC;
            """

            cursor.execute(sql)
            
            for row in cursor.fetchall():
                vaga = cls(id=row[0], titulo=row[1], descricao=row[2], data_publicacao=row[3], data_fim=row[4], carga_horaria=row[5], cnpj=row[9], cpf=row[10], id_tipo=row[11])

                vaga.nome_tipo = row[6]
                vaga.nome_empresa = row[7]
                vaga.nome_professor = row[8]

                vagas_obj.append(vaga)
        
        except Exception as e:
            print(f"Erro ao listar vagas: {e}")

        finally:
            if conn:
                cursor.close()
                conn.close()

        return vagas_obj
    
    @classmethod
    def get_by_id(cls, vaga_id):
        """Busca uma vaga específica pelo seu ID."""

        conn = None
        vaga_obj = None

        try:
            conn = connect_db()
            cursor = conn.cursor()
            
            sql = """
                SELECT v.id, v.titulo, v.descricao, v.data_publicacao, v.data_fim, v.carga_horaria,
                    t.nome as nome_tipo, e.nome_fantasia as nome_empresa, p.nome as nome_professor,
                    v.cnpj, v.cpf, v.id_tipo
                FROM VAGA v
                JOIN TIPO t ON v.id_tipo = t.id
                LEFT JOIN EMPRESA e ON v.cnpj = e.cnpj
                LEFT JOIN PROFESSOR prof ON v.cpf = prof.cpf
                LEFT JOIN PESSOA p ON prof.cpf = p.cpf
                WHERE v.id = %s
            """

            cursor.execute(sql, (vaga_id,))

            row = cursor.fetchone()
            if row:
                vaga_obj = cls(id=row[0], titulo=row[1], descricao=row[2], data_publicacao=row[3],
                               data_fim=row[4],carga_horaria=row[5], nome_tipo=row[6], 
                               nome_empresa=row[7], nome_professor=row[8], cnpj=row[9], 
                               cpf=row[10], id_tipo=row[11])
                
                
        except Exception as e:
            print(f"Erro ao buscar vaga por ID: {e}")

        finally:
            if conn:
                cursor.close()
                conn.close()

        return vaga_obj
    