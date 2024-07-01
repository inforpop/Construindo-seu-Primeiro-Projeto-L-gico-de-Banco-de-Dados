## Projeto Lógico de Banco de Dados

### Objetivo

Refinar e construir um banco de dados lógico que:
1. Diferencie clientes como Pessoa Jurídica (PJ) e Pessoa Física (PF).
2. Permita múltiplas formas de pagamento para cada pedido.
3. Inclua status e código de rastreio para cada entrega.

### Descrição do Projeto

Este projeto lógico de banco de dados irá detalhar as tabelas, colunas, tipos de dados e relacionamentos necessários para atender aos requisitos descritos. 

### Modelo Lógico

#### Tabela `Clientes`
Armazena informações básicas dos clientes, diferenciando entre PJ e PF.

```sql
CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    tipo_cliente CHAR(2) NOT NULL CHECK (tipo_cliente IN ('PJ', 'PF'))
);
```

#### Tabela `Clientes_PJ`
Armazena informações específicas de clientes Pessoa Jurídica.

```sql
CREATE TABLE Clientes_PJ (
    id_cliente INT PRIMARY KEY,
    cnpj VARCHAR(14) NOT NULL,
    razao_social VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);
```

#### Tabela `Clientes_PF`
Armazena informações específicas de clientes Pessoa Física.

```sql
CREATE TABLE Clientes_PF (
    id_cliente INT PRIMARY KEY,
    cpf VARCHAR(11) NOT NULL,
    data_nascimento DATE NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);
```

#### Tabela `Pedidos`
Armazena informações dos pedidos realizados pelos clientes.

```sql
CREATE TABLE Pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    data_pedido DATE NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);
```

#### Tabela `Pagamentos`
Armazena as diferentes formas de pagamento associadas a um pedido.

```sql
CREATE TABLE Pagamentos (
    id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    forma_pagamento VARCHAR(50) NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido)
);
```

#### Tabela `Entregas`
Armazena informações de entrega, incluindo status e código de rastreio.

```sql
CREATE TABLE Entregas (
    id_entrega INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    codigo_rastreio VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido)
);
```

### Relacionamentos

1. **Clientes**: 
   - Cada cliente é identificado como PJ ou PF, mas não ambos.
   - Relacionamentos entre `Clientes`, `Clientes_PJ` e `Clientes_PF` garantem que um cliente tenha informações específicas conforme seu tipo.

2. **Pedidos**: 
   - Cada pedido está associado a um cliente (`id_cliente` como FK em `Pedidos`).

3. **Pagamentos**: 
   - Cada pedido pode ter múltiplas formas de pagamento (`id_pedido` como FK em `Pagamentos`).

4. **Entregas**: 
   - Cada pedido tem uma entrega associada (`id_pedido` como FK em `Entregas`).

### Consultas Exemplo

Para listar todos os pedidos, formas de pagamento e status de entrega:

```sql
SELECT 
    p.id_pedido,
    c.nome,
    pg.forma_pagamento,
    pg.valor,
    e.status,
    e.codigo_rastreio
FROM 
    Pedidos p
JOIN 
    Clientes c ON p.id_cliente = c.id_cliente
LEFT JOIN 
    Pagamentos pg ON p.id_pedido = pg.id_pedido
LEFT JOIN 
    Entregas e ON p.id_pedido = e.id_pedido;
```

### Considerações Finais

Este projeto lógico oferece uma estrutura clara e robusta para o gerenciamento de clientes, pedidos, pagamentos e entregas. Seguindo este esquema, é possível implementar um banco de dados eficiente que atende aos requisitos do desafio proposto.
