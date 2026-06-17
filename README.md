# Avaliação e Síntese do Impacto da Pesquisa em Administração na Sociedade
[![DOI](https://zenodo.org/badge/1272570364.svg)](https://doi.org/10.5281/zenodo.20738101)
- **Versão atual:** 1.0.0

## Sobre o Projeto

Este repositório reúne os dados, códigos e procedimentos analíticos desenvolvidos no âmbito da Bolsa de Treinamento Técnico FAPESP nº **2025/11431-0**, intitulada **"Avaliação e síntese do impacto da pesquisa em Administração na sociedade"**, vinculada ao projeto de Auxílio à Pesquisa Regular FAPESP nº **2024/01491-2**, intitulado **"Avaliação de impacto da pós-graduação em administração na sociedade brasileira: proposta de um novo modelo"**.

O objetivo deste projeto é analisar como os Programas de Pós-Graduação em Administração descrevem e comunicam os impactos de suas atividades de pesquisa para a sociedade, utilizando técnicas de mineração de texto e análise automatizada de documentos.

Para isso, foi desenvolvido um procedimento automatizado de coleta para os Programas de Pós-Graduação da Área 27 da CAPES (Administração Pública e de Empresas, Ciências Contábeis e Turismo). A presente versão do repositório disponibiliza a base de dados referente aos programas da área de Administração, relativos ao ciclo de avaliação quadrienal **2017–2020**.

O repositório foi organizado para promover transparência metodológica, reprodutibilidade científica e compartilhamento dos dados e códigos utilizados na pesquisa.

---

# Objetivos

Os principais objetivos do projeto são:

* Construir uma base estruturada contendo os relatórios de impacto dos Programas de Pós-Graduação da Área 27;
* Organizar e documentar os dados utilizados na pesquisa;
* Identificar padrões discursivos presentes nos relatórios de impacto;
* Aplicar técnicas de mineração de texto para análise do corpus documental;
* Empregar modelagem de tópicos utilizando **Latent Dirichlet Allocation (LDA)**;
* Desenvolver procedimentos de classificação dos relatórios de impacto;
* Produzir evidências empíricas para subsidiar pesquisas sobre avaliação da pós-graduação e impacto social da ciência.

---

# Estrutura do Repositório

O repositório está organizado da seguinte forma:

```text
projeto-impacto/
│
├── CITATION.cff
├── Dados dos programas área 27.json
├── LICENSE
├── README.md
├── coleta CAPES.py
└── analise_lda.R
```

### Descrição dos Arquivos

| Arquivo                          | Descrição                                                                                                                                                                                             |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CITATION.cff                     | Contém as informações de citação do repositório em formato padronizado para plataformas acadêmicas e repositórios científicos.                                                                        |
| Dados dos programas área 27.json | Base de dados estruturada utilizada nas análises, contendo informações dos Programas de Pós-Graduação e os relatórios de impacto coletados.                                                           |
| LICENSE                          | Arquivo contendo os termos de licenciamento aplicáveis aos materiais disponibilizados neste repositório.                                                                                              |
| README.md                        | Documento principal de descrição do projeto, incluindo objetivos, documentação dos dados, procedimentos metodológicos e informações para reprodução da pesquisa.                                                                     |
| coleta CAPES.py                  | Script desenvolvido em Python para coleta automatizada de informações públicas disponibilizadas na Plataforma Sucupira da CAPES.                                                                      |
| analise_lda.R                    | Script desenvolvido em R contendo os procedimentos de pré-processamento textual, construção do corpus documental, modelagem de tópicos por Latent Dirichlet Allocation (LDA) e análises subsequentes. |


## Coleta de Dados

O script de coleta está disponível em formato Python:

📄 [coleta CAPES.py](coleta%20CAPES.py)

O arquivo contém um script desenvolvido em Python para obtenção automatizada de informações públicas disponibilizadas na Plataforma Sucupira da CAPES.

O coletor utiliza Selenium WebDriver para navegar pela plataforma e extrair os relatórios dos Programas de Pós-Graduação analisados.

A versão disponibilizada neste repositório corresponde à primeira versão funcional utilizada na pesquisa. Embora tenha sido suficiente para a construção da base de dados utilizada nas análises, o código ainda apresenta limitações e poderá demandar ajustes futuros em função de mudanças na estrutura da Plataforma Sucupira.

---

## Base de Dados

A base de dados utilizada nesta pesquisa está disponível em formato JSON:

📄 [Dados dos programas área 27.json](Dados%20dos%20programas%20%C3%A1rea%2027.json)

Ela contém informações dos Programas de Pós-Graduação em Administração pertencentes à Área 27 da CAPES, referentes ao ciclo de avaliação quadrienal **2017–2020**.

Os registros incluem informações institucionais dos programas, dados de identificação, localização geográfica, modalidade de oferta, notas de avaliação da CAPES e o conteúdo textual dos relatórios de impacto disponibilizados na Plataforma Sucupira.

O principal corpus utilizado nas análises corresponde ao campo **"Relatório de Impacto (Seção 3 completa)"**, que contém o texto integral da Seção 3 dos relatórios de impacto elaborados pelos Programas de Pós-Graduação.

### Estatísticas da Base

A base de dados disponibilizada neste repositório apresenta as seguintes características:

* Programas analisados: 118;
* Área de avaliação CAPES: Administração;
* Ciclo de avaliação: 2017–2020;
* Unidade de análise: Programa de Pós-Graduação;
* Corpus principal: Relatório de Impacto (Seção 3 completa);
* Formato dos dados: JSON;
* Data de coleta dos dados: setembro de 2025.

A coleta original foi realizada para os Programas de Pós-Graduação da Área 27 da CAPES. Entretanto, a base disponibilizada nesta versão do repositório contempla exclusivamente os programas da área de Administração que possuíam relatórios de impacto disponíveis no período analisado.

### Estrutura dos Registros

Cada registro da base representa um Programa de Pós-Graduação e possui a seguinte estrutura:

```json
{
  "Código do Programa": "31005012019P6",
  "Estado": "RJ",
  "ID": 13,
  "Instituição de Ensino": "PONTIFÍCIA UNIVERSIDADE CATÓLICA DO RIO DE JANEIRO",
  "Modalidade": "Aca.",
  "Nome corrigido": "\"PONTIFÍCIA UNIVERSIDADE CATÓLICA DO RIO DE JANEIRO\",",
  "Nota da Avaliação": 6,
  "Programa": "ADMINISTRAÇÃO DE EMPRESAS",
  "Região": "Sudeste",
  "Área": "Administração",
  "Relatório Impacto (Seção 3 completa)": "Texto integral do relatório..."
}
```

### Descrição dos Campos

| Campo                                | Descrição                                                                                |
| ------------------------------------ | ---------------------------------------------------------------------------------------- |
| Código do Programa                   | Identificador oficial do Programa de Pós-Graduação na CAPES                              |
| Estado                               | Unidade federativa da instituição de ensino                                              |
| ID                                   | Identificador interno utilizado durante o processamento dos dados                        |
| Instituição de Ensino                | Nome da instituição responsável pelo programa                                            |
| Modalidade                           | Modalidade do programa (Acadêmico ou Profissional)                                       |
| Nome corrigido                       | Campo padronizado utilizado durante o tratamento dos dados                               |
| Nota da Avaliação                    | Conceito atribuído pela CAPES no ciclo de avaliação                                      |
| Programa                             | Nome do Programa de Pós-Graduação                                                        |
| Região                               | Região geográfica brasileira onde o programa está localizado                             |
| Área                                 | Área de avaliação CAPES associada ao programa                                            |
| Relatório Impacto (Seção 3 completa) | Texto integral da Seção 3 do relatório de impacto disponibilizado na Plataforma Sucupira |

Os arquivos disponibilizados preservam os dados originais coletados durante a pesquisa e constituem o corpus utilizado nas análises de mineração de texto, modelagem de tópicos por Latent Dirichlet Allocation (LDA) e classificação dos relatórios de impacto.

---

## Processamento e Análise

O script de análise está disponível em formato R:

📄 [analise_lda.R](analise_lda.R)

O script desenvolvido em R realiza as etapas de preparação e tratamento dos dados para análise.

Entre as atividades realizadas estão:

* Importação dos arquivos JSON;
* Limpeza e normalização textual;
* Remoção de conteúdo não informativo;
* Construção do corpus documental;
* Preparação dos dados para mineração de texto;
* Preparação dos documentos para modelagem de tópicos;
* Preparação dos dados para classificação dos relatórios.

As análises subsequentes utilizam técnicas de mineração de texto e modelagem de tópicos por meio do algoritmo **Latent Dirichlet Allocation (LDA)**, permitindo identificar temas recorrentes e padrões de descrição dos impactos relatados pelos programas.

---

# Reprodutibilidade

Este repositório foi estruturado para permitir a reprodução das etapas realizadas na pesquisa.

Os materiais disponibilizados incluem:

* Script de coleta automatizada em Python;
* Base de dados original em formato JSON;
* Script de processamento e análise em R;
* Documentação necessária para replicação dos procedimentos.

Embora o estudo tenha sido desenvolvido especificamente para a Área 27 da CAPES (Administração, Ciências Contábeis e Turismo), a metodologia pode ser adaptada para outras áreas de avaliação mediante adequações nos procedimentos de coleta e tratamento dos dados.

## Fluxo Geral de Reprodução

A reprodução das análises pode ser realizada por meio das seguintes etapas:

1. Executar o script de coleta em Python para obtenção dos dados diretamente na Plataforma Sucupira (opcional);

2. Utilizar a base de dados disponibilizada em formato JSON, que já corresponde ao conjunto de dados estruturado utilizado na pesquisa;

3. Executar o script em R para realização do pré-processamento textual, construção do corpus documental, modelagem de tópicos e análises subsequentes.

Como a base de dados utilizada nas análises já está disponibilizada neste repositório, a reprodução das etapas analíticas pode ser realizada diretamente a partir do arquivo JSON, sem necessidade de executar previamente o script de coleta.

---

# Financiamento

Esta pesquisa recebeu apoio da Fundação de Amparo à Pesquisa do Estado de São Paulo (FAPESP).

### Bolsa de Treinamento Técnico

* Processo: **2025/11431-0**
* Título: *Avaliação e síntese do impacto da pesquisa em Administração na sociedade*

### Auxílio à Pesquisa Regular

* Processo: **2024/01491-2**
* Título: *Avaliação de impacto da pós-graduação em administração na sociedade brasileira: proposta de um novo modelo*

As opiniões, hipóteses, conclusões e recomendações expressas neste material são de responsabilidade exclusiva dos autores.

---

# Uso de Inteligência Artificial Generativa

Ferramentas de inteligência artificial generativa, incluindo Google Gemini e ChatGPT, foram utilizadas como apoio ao desenvolvimento dos scripts computacionais, identificação e correção de erros de programação, revisão de código, documentação técnica e organização deste repositório.

Essas ferramentas foram empregadas exclusivamente como instrumentos auxiliares de desenvolvimento e suporte técnico.

Todas as decisões metodológicas, definições analíticas, procedimentos de coleta, validações dos resultados, interpretações científicas, elaboração das análises e conclusões da pesquisa foram conduzidas, verificadas e supervisionadas pelos pesquisadores responsáveis.

A utilização dessas ferramentas não substituiu o julgamento científico dos pesquisadores em nenhuma etapa do projeto.

---

# Requisitos

## Softwares utilizados

* Python 3.10 ou superior;
* R 4.3 ou superior;
* Google Chrome;
* ChromeDriver compatível com a versão instalada do Google Chrome.

Ambientes recomendados para execução:

* Visual Studio Code;
* RStudio.

## Dependências

As bibliotecas e pacotes necessários para execução dos scripts estão especificados nos respectivos códigos-fonte.

## ChromeDriver

Download oficial:

https://googlechromelabs.github.io/chrome-for-testing/

---

# Limitações

Este repositório foi desenvolvido com o objetivo de promover transparência e reprodutibilidade científica. Entretanto, algumas limitações devem ser consideradas.

A coleta dos dados foi realizada a partir de informações públicas disponibilizadas pela Plataforma Sucupira da CAPES em um período específico de acesso. Alterações posteriores na estrutura da plataforma, nos mecanismos de disponibilização dos dados ou no conteúdo dos relatórios podem impedir a reprodução exata do processo de coleta descrito neste repositório.

A versão disponibilizada do coletor corresponde à primeira implementação funcional utilizada na pesquisa. Embora tenha sido suficiente para obtenção do corpus analisado, o código ainda pode demandar atualizações para garantir compatibilidade com futuras modificações da plataforma.

A base de dados representa uma fotografia dos dados disponíveis no momento da extração e não deve ser interpretada como uma versão permanentemente atualizada das informações mantidas pela CAPES.

Os resultados produzidos a partir das análises de mineração de texto, modelagem de tópicos e classificação documental dependem das escolhas metodológicas adotadas nesta pesquisa e não constituem interpretações únicas ou definitivas sobre os impactos da pós-graduação em Administração na sociedade brasileira.

---

# Aviso sobre os Dados

Os dados disponibilizados neste repositório foram obtidos a partir de informações públicas disponibilizadas pela CAPES por meio da Plataforma Sucupira.

Os autores não reivindicam direitos autorais sobre os textos originais produzidos pelos Programas de Pós-Graduação e disponibilizados nos relatórios institucionais.

O conjunto de dados disponibilizado neste repositório corresponde ao processo de coleta, organização, estruturação e preparação dos dados realizado para fins de pesquisa científica.

Usuários interessados em reutilizar os dados são responsáveis por verificar eventuais restrições, atualizações ou políticas de uso estabelecidas pelos sistemas e instituições de origem.

---

# Licença

A organização, estruturação e disponibilização da base de dados realizada pelos autores está disponibilizada sob a licença Creative Commons Attribution 4.0 International (CC BY 4.0).

Os textos originais dos relatórios permanecem sujeitos às condições de uso e às políticas definidas pelas instituições responsáveis por sua disponibilização.

---

# Como Citar

As informações de citação também estão disponíveis no arquivo `CITATION.cff`, compatível com os mecanismos automáticos de citação do GitHub.

Caso utilize os dados, códigos ou procedimentos disponibilizados neste repositório, recomenda-se citar:

> ROBUSTI, César da Silva; SANDES-GUIMARÃES, Luisa Veras de. Avaliação e síntese do impacto da pesquisa em Administração na sociedade. Version 1.0.0 Zenodo, 2026. DOI: 10.5281/zenodo.20738101.
