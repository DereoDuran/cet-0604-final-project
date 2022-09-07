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

O script [`create_schema.sql`](create_schema.sql) contém os comandos de criação das tabelas e a seguir damos uma breve descrição do que cada coluna representa:

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

Os detalhes de como os dados fictícios de cada tabela foram gerados podem ser encontrados no notebook [`populate_db.ipynb`](populate_db.ipynb). Tentamos ser realistas na geração dos dados (por exemplo, escolas do nível Elementary só possuem turmas Elementary, turmas da manhã só têm aulas das 8h até 12h, etc), mas como o foco do projeto é a otimização, optamos por manter algumas inconsistências (por exemplo, professores podem dar mais de uma aula mesmo tempo).

Assumimos que esse é o estado no qual a nossa equipe recebeu a base de dados para executar o projeto.

3.  Oportunidades de Otimização

    3.1 Correção de tipos de colunas: Identificamos que algumas colunas estão definidas com o tipo ideal para o dado que estão armazenando. 
