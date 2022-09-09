## Especialização em Engenharia e Adm. de Sistemas de Banco de dados 
### Projeto Final - CET 0604 - Programação e Otimização em SQL
### Integrantes do grupo:

- José Cabadas
- Gabriel Sari
- Mirray Teixeira
- André Martins

<hr>

1.  Contexto

Nossa equipe foi contratada por um grupo de escolas norte-americano chamado **Tetrahedron** para um projeto de consultoria. A principais queixas trazidas por eles estão relacionadas a problemas de funcionamento de um programa de uso interno pela coordenação, cuja principal função é realizar o controle de aulas de todas as escolas de grupo. O Tetrahedron Group já existe há mais de 20 anos e tem um total de 100 escolas espalhadas por vários estados norte-americanos. Com o tempo, a coordenação vem notando uma degradação visível no funcionamento desse programa de controle e precisa de nossa ajuda para melhor a experiência dos seus funcionários, que hoje perdem muito tempo para executar algumas tarefas. Como esse programa utiliza um banco de dados local, nossa equipe foi chamada para encontrar oportunidades de otimização e executar melhorias com foco em performance e redução de custos.

2.  Criação da Base de Dados

Para criar a base de dados fictícia, partimos da tabela fato **Aulas** (*lessons*) e construímos as seguintes dimensões associadas: **Datas** (*dates*),  **Escolas** (*schools*),  **Disciplinas** (*school_subjects*),  **Professores** (*teachers*),  **Tipos de aula** (*class_types*),  **Salas de aula** (*classrooms*) e **Turmas** (*classes*). 

O script [`2_1_create_schema.sql`](schools/scripts/2_1_create_schema.sql) contém os comandos de criação das tabelas e a seguir mostramos a representação da modelagem e damos uma breve descrição do que cada coluna representa:

![database schema](schools/images/model.png)

    Tabela class_types
    - class_type_id (int): Chave primária
    - type (char (20)): Tipo de aula (ONLINE, IN PERSON)

    Tabela classes
    - class_code (char (6)): Código no formato abc123 usado para identificação da turma
    - class_id (int): Chave primária 
    - class_level (char (20)): Nível da aula (Elementary, Middle, High)
    - class_period (char (20)): Horário da aula (Morning, Afternoon, Evening)
    - students (int): Número de alunos

    Tabela classrooms
    - classroom_code (char (6)): Código no formato abc123 usado para identificação da sala
    - classroom_id (int): Chave primária

    Tabela dates
    - date (date): Data
    - date_id (int): Chave primária
    - day (int): Dia
    - day_of_year (int): Ordem do dia no ano
    - is_holiday (tinyint): Dia é feriado
    - is_weekend (tinyint): Dia é fim-de-semana
    - month (int): Ordem do mês no ano (1-12)
    - weekday (int): Ordem nos dias da semana (0-6)
    - year (int): Ano

    Tabela lessons
    - attendance (int): Alunos presentes na aula
    - class_end (int): Hora final da aula
    - class_id (int): Chave estrangeira da turma
    - class_start (int): Hora de início da aula
    - class_type_id (int): Chave estrangeira do tipo de aula
    - classroom_id (int): Chave estrangeira da sala de aula
    - date_id (int): Chave estrangeira da data da aula
    - lesson_id (int): Chave primária
    - school_id (int): Chave estrangeira da escola
    - school_subject_id (int): Chave estrangeira da disciplina
    - teacher_id (int): Chave estrangeira do professor

    Tabela school_subjects
    - code (char (3)): Abreviação (Ex.: SCI, para Science)
    - school_subject (varchar (255)): Nome da disciplina
    - school_subject_id (int): Chave primária

    Tabela schools
    - max_students (int): Capacidade máxima de estudantes
    - school_district (varchar (255)): Distrito da escola
    - school_id (int): Chave primária
    - school_level (varchar (255)): Grau da escola (Elementary, Middle, High)
    - school_name (varchar (255)): Nome da escola
    - school_state (varchar (255)): Estado da escola

    Tabela teachers
    - birthdate (date): Data de nascimento
    - email (varchar (255)): E-mail
    - end_year (int): Ano que parou de lecionar
    - sex (char (1)): Sexo
    - start_year (int): Ano que começou a lecionar
    - teacher_id (int): Chave primária
    - teacher_name (varchar (255)): Nome do professor

Os detalhes de como os dados fictícios de cada tabela foram gerados podem ser encontrados no notebook [`2_2_populate_db.ipynb`](schools/notebooks/2_2_populate_db.ipynb). Tentamos ser realistas na geração dos dados (por exemplo, escolas do nível Elementary só possuem turmas Elementary, turmas da manhã só têm aulas das 8h até 12h, etc), mas como o foco do projeto é a otimização, optamos por manter algumas inconsistências (por exemplo, professores podem dar mais de uma aula mesmo tempo).

Assumimos que esse é o estado no qual a nossa equipe recebeu a base de dados para executar o projeto.

3.  Oportunidades de Otimização

    3.1 **Correção de tipos de colunas**: Identificamos que algumas colunas estão definidas com o tipo ideal para o dado que estão armazenando. Sendo assim, propusemos que inicialmente sejam feitas alterações para os tipos de certas colunas, sendo elas:
    
        Tabela dates
        - date_id UNSIGNED INT
        - year UNSIGNED SMALLINT
        - month UNSIGNED TINYINT
        - day UNSIGNED TINYINT
        - weekday UNSIGNED TINYINT
        - day_of_year UNSIGNED TINYINT
        - is_holiday UNSIGNED TINYINT(1)
        - is_weekend UNSIGNED TINYINT(1)

        Tabela schools
        - school_id UNSIGNED INT
        - school_name CHAR(50)
        - school_district CHAR(30)
        - school_level CHAR(20)
        - school_state CHAR(2)
        - max_students UNSIGNED INT

        Tabela school_subjects
        - school_subject_id UNSIGNED INT
        - school_subject CHAR(30)

        Tabela classrooms
        - classroom_id UNSIGNED INT

        Tabela class_types
        - class_type_id UNSIGNED INT

        Tabela teachers
        - teacher_id UNSIGNED INT
        - teacher_name CHAR(50)   
        - start_year UNSIGNED SMALLINT
        - end_year UNSIGNED SMALLINT

        Tabela classes
        - class_id UNSIGNED INT
        - students UNSIGNED SMALLINT

        Tabela lessons   
        - lesson_id UNSIGNED INT
        - school_id UNSIGNED INT
        - class_id UNSIGNED INT
        - date_id UNSIGNED INT
        - school_subject_id UNSIGNED INT
        - teacher_id UNSIGNED INT
        - classroom_id UNSIGNED INT
        - class_type_id UNSIGNED INT
        - class_start UNSIGNED TINYINT
        - class_end UNSIGNED TINYINT
        - attendance UNSIGNED SMALLINT

    O script usado para alteração das colunas pode ser visto em [`3_1_alter_columns.sql`](schools/scripts/3_1_alter_columns.sql)

    3.2 **Arquivamento de dados**: Após conversar com a coordenação da escola, entendemos que, apesar do banco de dados armazenar informações de mais de 20 anos, apenas informações dos últimos 10 anos eram necessárias para geração dos relatórios que eles utilizavam no dia-a-dia. Sendo assim, propusemos que as informações relacionadas a aulas do período anterior a esse fossem arquivadas, e dessa forma todas as queries se beneficiariam dessa redução da base. No arquivo [`3_2_data_archive.sql`](schools/scripts/3_2_data_archive.sql), mostramos o script que foi executado para separar a informação de aulas antigas em uma tabela separada. 

    3.3 **Criação de índices**: 