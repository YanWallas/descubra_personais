# Desafio Técnico Flutter – Plataforma de Descoberta de Personais

Projeto desenvolvido como parte do desafio técnico para a vaga de Desenvolvedor Flutter. O objetivo foi construir um aplicativo para buscar, visualizar e simular a contratação de personais trainers, consumindo dados de uma API REST mockada.
<br>
<p align="center">
  <img src="assets/demo.gif" alt="Demonstração do App" width="300"/>
</p>
<br>
## ✨ Features

-   **Listagem de Personais:** Visualização de todos os profissionais disponíveis com suas informações principais.
-   **Busca e Filtro:** Funcionalidades para buscar um personal pelo nome e filtrar por especialidades.
-   **Tela de Detalhes:** Exibição completa do perfil do personal, incluindo biografia, preço e avaliações.
-   **Simulação de Contratação:** Fluxo para o usuário escolher modalidade (online/presencial) e frequência, com cálculo de valor mensal estimado e envio de interesse.
-   **Contato via WhatsApp:** Integração para abrir uma conversa diretamente no WhatsApp do personal.

<br>

## 🏛️ Arquitetura

O projeto foi estruturado com base nos princípios de **Clean Architecture**, dividindo as responsabilidades em 3 camadas principais para garantir um código limpo, testável e escalável.

### Camada de `Domain`
É o núcleo do aplicativo, totalmente independente de qualquer implementação de UI ou fonte de dados.
-   **Entities:** Representam os objetos de negócio puros (ex: `PersonalEntity`).
-   **Repositories (Abstrações):** Definem os "contratos" que a camada de dados deve implementar (ex: `PersonalRepository`), garantindo o princípio da inversão de dependência.

### Camada de `Data`
Responsável pela implementação concreta da obtenção e armazenamento de dados.
-   **Models:** Extensões das entidades que sabem como ser criadas a partir de um JSON e convertidas para outros formatos.
-   **Datasources:** Classes que têm a responsabilidade única de se comunicar com fontes de dados externas, como uma API REST (ex: `PersonalRemoteDatasource` que usa o pacote `http`).
-   **Repositories (Implementações):** Implementam os contratos definidos na camada de `Domain`, orquestrando os `Datasources` para entregar os dados.

### Camada de `Presentation`
A camada responsável por tudo que o usuário vê e interage.
-   **Pages/Views:** As telas do aplicativo, construídas de forma reativa com Widgets do Flutter.
-   **Controllers/State Management:** Lógica de UI e gerenciamento de estado (neste projeto, foi utilizado `StatefulWidget` com `setState` para estados locais).

<br>

## 🚀 Como Rodar o Projeto

Siga os passos abaixo para executar o projeto localmente.

**1. Clone o repositório:**
```bash
git clone [https://github.com/YanWallas/descubra_personais.git](https://github.com/YanWallas/descubra_personais.git)
cd descubra_personais
```

**2. Instale as dependências:**
```bash
flutter pub get
```

**3. Inicie o Mock Server:**
O projeto utiliza um `db.json` para simular a API. Para iniciá-lo, você precisa ter o `json-server` instalado globalmente (`npm install -g json-server`).

```bash
# Na raiz do projeto, onde o arquivo db.json está, rode:
json-server --host 0.0.0.0 --watch db.json
```
O `--host 0.0.0.0` permite que o emulador Android acesse o `localhost` da sua máquina.

**4. Rode o aplicativo Flutter:**
Com o servidor mock rodando, execute o app em um emulador ou dispositivo.
```bash
flutter run
```

<br>

## 🔌 API Mock (json-server)

A API foi simulada localmente com `json-server`.

-   **Endpoint Base:** `http://localhost:3000`
-   **Recursos:**
    -   `GET /personals`
    -   `POST /contact-interest`

O arquivo de configuração da base de dados é o `db.json`, localizado na raiz do projeto.

<br>

---

Desenvolvido por **Yan Wallas**.
