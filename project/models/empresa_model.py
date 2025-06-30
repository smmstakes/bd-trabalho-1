from database.connection import connect_db

class Empresa:
    def __init__(self, cnpj, nome_fantasia, ramo_atividade, site, email, cep, complemento_end, numero_end):
        self.cnpj = cnpj
        self.nome_fantasia = nome_fantasia
        self.ramo_atividade = ramo_atividade
        self.site = site
        self.email = email
        self.cep = cep
        self.complemento_end = complemento_end
        self.numero_end = numero_end
    
    @classmethod
    def get_all(cls):
        empresas = []
        conn = connect_db()

        if not conn:
            return empresas
        
        try:
            cursor = conn.cursor()

            sql = """
                SELECT cnpj, nome_fantasia, ramo_atividade, site_emp, email, cep_end, complemento_end, numero_end
                FROM Empresa
                ORDER BY nome_fantasia
                """
            
            cursor.execute(sql)

            for row in cursor.fetchall():
                empresas.append(cls(cnpj=row[0], nome_fantasia=row[1], ramo_atividade=row[2],
                                    site=row[3], email=row[4], cep=row[5], complemento_end=row[6],
                                    numero_end=row[7]))
        
        finally:
            if conn:
                cursor.close()
                conn.close()

        return empresas
    