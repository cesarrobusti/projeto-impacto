# 1. Instalação e Carregamento dos Pacotes Básicos Necessários ----
if(!require(jsonlite)) install.packages("jsonlite")
if(!require(tm)) install.packages("tm")
if(!require(topicmodels)) install.packages("topicmodels")
if(!require(tidyverse)) install.packages("tidyverse")
if(!require(tidytext)) install.packages("tidytext")
if(!require(wordcloud)) install.packages("wordcloud")
if(!require(reshape2)) install.packages("reshape2")
if(!require(ggraph)) install.packages("ggraph")
if(!require(igraph)) install.packages("igraph")

library(jsonlite)
library(tm)
library(topicmodels)
library(tidyverse)
library(tidytext)

# 
# 2. CARREGAR E PREPARAR DADOS ====
#
# Ajuste o caminho para onde salvou seu arquivo JSON
caminho_arquivo <- "C:/Users/cesar/Downloads/Projeto_Impacto/Github/Dados dos programas área 27.json" 

# Lê o JSON
dados_raw <- fromJSON(caminho_arquivo)

dados_trabalho <- dados_raw %>%
  # Seleciona as colunas e renomeia
  select(id = ID, instituicao = `Instituição de Ensino`, texto = `Relatório Impacto (Seção 3 completa)`) %>%
  as_tibble() %>%
  # --- CORREÇÃO AQUI: REMOVE LINHAS ONDE O TEXTO É NA ---
  filter(!is.na(texto)) %>%
  # Opcional: Remove também textos que ficaram vazios ("") mas não são NA
  filter(texto != "")

# Verifica quantos sobraram
print(paste("Documentos válidos após remover NAs:", nrow(dados_trabalho)))

#
# 3. LIMPEZA ESPECÍFICA ====
#

# 1. Lista exata das frases que você quer remover
# DICA: Copie exatamente como estão nos documentos.
lista_cabecalhos <- c(
  "3.1 Impacto e caráter inovador da produção intelectual em função da natureza do programa",
  "3.2 Impacto econômico, social e cultural do programa",
  "3.3 Internacionalização, inserção (local, regional, nacional) e visibilidade do programa",
  "3.1.1. Clareza e consistência da política de incentivo ao impacto da produção intelectual do PPG",
  "3.1.2. Consistência da justificativa de impacto e aderência à proposta, objetivos e modalidade dos 10 melhores produtos do Programa no quadriênio",
  "3.1.3. Evidência de impacto do docente permanente baseado em métricas de citação",
  "3.1.4. Evidência de impacto do docente permanente baseado em outras métricas de repercussão",
  "pontifícia universidade católica do rio de janeiro",
  "centro universitário campo limpo paulista",
  "fundação getulio vargas",
  "universidade presbiteriana mackenzie",
  "fundação getulio vargas",
  "universidade de são paulo",
  "universidade presbiteriana mackenzie",
  "fucape pesquisa e ensino",
  "universidade federal rural de pernambuco",
  "universidade federal do rio de janeiro",
  "universidade estácio de sá",
  "pontifícia universidade católica do rio grande do sul",
  "universidade federal de são carlos",
  "universidade federal de santa catarina",
  "escola superior de propaganda e marketing",
  "universidade de são paulo",
  "fundação getulio vargas",
  "fundação getulio vargas",
  "fundação joão pinheiro",
  "fundação getulio vargas",
  "universidade de fortaleza",
  "universidade de são paulo",
  "universidade de fortaleza",
  "universidade do estado de santa catarina",
  "pontifícia universidade católica de são paulo",
  "universidade do estado de santa catarina",
  "universidade do oeste de santa catarina",
  "fundação getúlio vargas",
  "universidade do oeste de santa catarina",
  "universidade federal fluminense",
  "centro universitário fecap",
  "universidade anhembi morumbi",
  "universidade federal fluminense",
  "universidade metodista de piracicaba",
  "universidade metodista de piracicaba",
  "universidade potiguar",
  "universidade federal de santa catarina",
  "universidade potiguar",
  "universidade do vale do itajaí",
  "centro federal de educação tecnológica de minas gerais",
  "centro universitário álvares penteado",
  "centro universitário alves faria",
  "centro universitário da fundação educacional inaciana pe sabóia de medeiros",
  "centro universitário ibmec",
  "universidade do vale do rio dos sinos",
  "universidade de caxias do sul",
  "escola superior de propaganda e marketing",
  "faculdade atitus educação passo fundo",
  "faculdade pedro leopoldo",
  "universidade de passo fundo",
  "universidade federal do paraná",
  "insper instituto de ensino e pesquisa",
  "pontifícia universidade católica de minas gerais",
  "universidade de são paulo",
  "pontifícia universidade católica de são paulo",
  "pontifícia universidade católica do paraná",
  "universidade da amazônia",
  "universidade de brasília",
  "universidade regional de blumenau",
  "universidade de brasília",
  "universidade de caxias do sul",
  "universidade de santa cruz do sul",
  "universidade de são paulo",
  "universidade do estado do rio de janeiro",
  "universidade de são paulo",
  "universidade do contestado",
  "universidade do grande rio professor josé de souza herdy",
  "universidade do sul de santa catarina",
  "universidade do vale do itajaí",
  "universidade do vale do rio dos sinos",
  "universidade estadual de campinas",
  "universidade federal da bahia",
  "universidade federal de minas gerais",
  "universidade estadual de londrina",
  "universidade federal do rio grande do norte",
  "universidade estadual de maringá",
  "universidade presbiteriana mackenzie",
  "universidade federal de pernambuco",
  "escola de administração de empresas de são paulo",
  "fucape pesquisa e ensino",
  "universidade federal do ceará",
  "universidade estadual do ceará",
  "universidade estadual do centro",
  "universidade federal do ceará",
  "universidade estadual do oeste do paraná",
  "universidade estadual paulista júlio de mesquita filho",
  "universidade federal da bahia",
  "universidade federal da bahia",
  "universidade federal do espírito santo",
  "universidade federal da paraíba",
  "universidade federal de campina grande",
  "universidade federal de goiás",
  "universidade federal do espírito santo",
  "universidade federal de santa maria",
  "universidade federal de itajubá",
  "universidade federal de juiz de fora",
  "universidade federal de lavras",
  "universidade federal do rio grande do norte",
  "universidade federal de mato grosso do sul",
  "universidade federal de minas gerais",
  "universidade federal de pernambuco",
  "universidade federal de rondônia",
  "universidade federal de santa catarina",
  "universidade federal de lavras",
  "universidade federal de santa maria",
  "universidade federal de sergipe",
  "universidade federal de uberlândia",
  "universidade federal de viçosa",
  "universidade federal do espírito santo",
  "universidade federal do pampa",
  "universidade federal do paraná",
  "universidade de são paulo",
  "universidade federal do pará",
  "universidade federal do paraná",
  "universidade federal de uberlândia",
  "universidade federal do rio de janeiro",
  "universidade federal do rio grande",
  "universidade federal do rio grande do norte",
  "universidade de brasília",
  "universidade federal do rio grande do sul",
  "universidade federal rural do semi",
  "universidade feevale",
  "universidade fumec",
  "universidade estadual de maringá",
  "universidade federal de pelotas",
  "universidade de são paulo",
  "associação nacional dos dirigentes das instituições federais de ensino superior",
  "universidade municipal de são caetano do sul",
  "universidade de brasília",
  "universidade nove de julho",
  "universidade paulista",
  "universidade federal do rio grande do norte",
  "universidade positivo",
  "universidade regional de blumenau",
  "universidade salvador",
  "universidade federal rural de pernambuco",
  "universidade estadual do oeste do paraná",
  "universidade federal da paraíba",
  "fucape pesquisa e ensino",
  "universidade tecnológica federal do paraná",
  "faculdade fipecafi",
  "universidade ibirapuera",
  "universidade do vale do itajaí",
  "universidade federal fluminense",
  "fundação dom cabral",
  "universidade comunitária da região de chapecó",
  "pontifícia universidade católica do paraná",
  "universidade federal de alagoas",
  "instituto brasileiro de ensino, desenvolvimento e pesquisa de brasília",
  "instituto federal de educação, ciência e tecnologia de sergipe",
  "universidade federal dos vales do jequitinhonha e mucuri",
  "faculdade fia de administração e negócios",
  "universidade federal do paraná",
  "universidade nove de julho",
  "universidade de pernambuco",
  
  #ESTADOS BRASILEIROS
  "acre", "alagoas", "amapá", "amazonas", "bahia", "ceará", "distrito federal",
  "espírito santo", "goiás", "maranhão", "mato grosso", "mato grosso do sul",
  "minas gerais", "pará", "paraíba", "paraná", "pernambuco", "piauí",
  "rio de janeiro", "rio grande do norte", "rio grande do sul",
  "rondônia", "roraima", "santa catarina", "são paulo",
  "sergipe", "tocantins",

#PAÍSES - adicionados em 30/01/2026
"brasil","estados unidos","canadá","reino unido","inglaterra","escócia","irlanda",
"frança","alemania","itália","espanha","portugal","holanda","bélgica","suíça",
"suécia","noruega","dinamarca","finlândia","áustria","polônia","república tcheca",
"hungria","grécia","turquia",
"austrália","nova zelândia",
"japão","coreia do sul","china","hong kong","singapura","índia",
"argentina","chile","colômbia","méxico","uruguai","paraguai","peru",
"africa do sul","egito","marrocos",
"israel","emirados árabes unidos","arabia saudita",
"russia"
)

# 2. Função auxiliar para transformar texto comum em REGEX robusto
# Isso evita que pontos (.) ou parenteses () quebrem o código e 
# garante que espaços peguem também quebras de linha
gerar_padrao_robusto <- function(texto) {
  texto %>%
    # Escapa caracteres especiais do Regex
    str_replace_all("\\.", "\\\\.") %>% 
    str_replace_all("\\(", "\\\\(") %>% 
    str_replace_all("\\)", "\\\\)") %>% 
    # Transforma qualquer espaço simples em "pelo menos um espaço ou quebra de linha"
    str_replace_all("\\s+", "\\\\s+")
}

# Cria um padrão único gigante unindo todas as frases com "OU" (|)
padrao_final <- paste0(sapply(lista_cabecalhos, gerar_padrao_robusto), collapse = "|")

print("Padrão de limpeza gerado. Aplicando aos textos...")

dados_limpos <- dados_trabalho %>%
  # 1. Converte para minúsculo
  mutate(texto_proc = tolower(texto)) %>%
  
  # 2. REMOVE TODAS AS FRASES DA LISTA DE UMA VEZ
  # ignore_case = TRUE garante que pegue mesmo se houver diferença de maiúsculas
  mutate(texto_proc = str_remove_all(texto_proc, regex(padrao_final, ignore_case = TRUE))) %>%
  
  # xx. UNIFICAÇÃO DE TERMOS (Singular/Plural)
  # Faz a troca antes de limpar pontuação para garantir a integridade das palavras
  mutate(texto_proc = texto_proc %>%
           str_replace_all("projetos", "projeto") %>%
           str_replace_all("escolas", "escola") %>%
           str_replace_all("temas", "tema") %>%
           str_replace_all("artigos", "artigo") %>%
           str_replace_all("serviços", "serviço") %>%
           str_replace_all("programas", "programa") %>%
           str_replace_all("empresas", "empresa") %>%
           str_replace_all("alunos", "aluno") %>%
           str_replace_all("periódicos", "periódico") %>%
           str_replace_all("discentes", "aluno") %>% # Unifica discente com aluno
           str_replace_all("ações", "ação") %>%
           str_replace_all("públicas", "pública") %>%
           str_replace_all("docentes", "docente") %>%
           str_replace_all("ações", "ação") %>%
           str_replace_all("instituições", "instituicao")
  ) %>%
  
  # 4. Limpeza padrão (pontuação, números, espaços)
  mutate(texto_proc = str_replace_all(texto_proc, "[[:punct:]]", " ")) %>%
  mutate(texto_proc = str_replace_all(texto_proc, "[0-9]+", " ")) %>%
  mutate(texto_proc = str_squish(texto_proc)) # Remove espaços duplos que sobraram

# Verificação: Mostra os primeiros 200 caracteres de um texto para ver se o cabeçalho sumiu
print(substr(dados_limpos$texto_proc[1], 1, 200))

#
# 4. CRIAÇÃO DO CORPUS E REMOÇÃO DE STOPWORDS ====
#
# Cria o objeto Corpus que a biblioteca 'tm' exige
corpus <- VCorpus(VectorSource(dados_limpos$texto_proc))

# Lista de palavras para ignorar (Baseada na sua experiência anterior)
minhas_stopwords <- c(
  # 1. Listas Padrão
  stopwords("portuguese"),
  stopwords("english"), # <--- IMPORTANTE: Remove 'the', 'and', 'of'
  
  # 2. Termos Institucionais e Siglas
  "ppga", "ppg", "mpa", "mpcc", "mpge", "prof", "profa", "professores", 
  "docentes", "alunos", "discente", "brasil", "estado",
  "instituicao", "university", "universidade", 
  
  #Palavras removidas 22/12/25
  "minas", "professor", "ppad", "fernandes", "pmpgil", "sehnem", "paulo", "pernambuco", "ppgadm", "maria", "bahia", "propadm", "sul", "rio", "ana", "catarina", "santa", 'silva', "carvalo", "pmpgil", "univali", "furb", "sehnem", "npga", "ufs",  "unifor", "uece", "uninove", "ppgad", "ppgp", "puc", "ppgadm", "usp", "fgv", "eaesp", "espm", "rio", "ucs", "ppad", "unp", "uel", "ufsm", "feevale", "ebape", "catarina", "santa", "coppead", "oe", "ppg", "usp", "unicamp", "fgv", "unesp", "esalq", "unioeste", "unipampa", "ufrn",
  "ppggo", "gondim", "antônio", "ufja", "ppggeo", "ufes", "unir", "fdc", "propad", "ufmg", "ceará", "fernando", "pucrs", "pucpr", "uff", "ppge", "ppga", "udesc", "fea", "fia", "fei", "florianópolis", "ies", "andré", "ppgcoop", "ppgn", "alegre", "padr", "vasconcellos", "padilha", "sampaio", "balestrin", "cristina", "antonio", "professor", "professora", "simone", "machado", "jabbour", "halmstad", "université", "luciana", "fzea", "pedro", "roberto", "santos", "journal", "international", "ferreira", "carlos", "floriani", "laval", "aveiro", "ainda", "sob", "carvalho", "sobre", "eira", "caxias", "barros","gdls", "universidad", "mestrado", "doutorado", "academy", "research","ndp", "giia", "school", "então", "barbosa", "alexandre", "costa","iag", "eduardo", "oliveira", "luciano", "adriana", "salvador", "costa", "sousa", "recife", "gss", "piracicaba", "vieira", "através", "dinorá", "cruz", "josé", "fortaleza", "rezende", "paula", "adm", "marcelo", "mpgn", "map", "eua", "review", "souza", "filho", "supply", "production", "jorge", "guilherme", "alsones", "poítiers", "neto", "discentes", "brazilian", "pinto", "nesse", "deste", "nordeste", "mohamed", "inglês", "cascavel", "del", "seibert", "brazil", "amazônia", "dentre", "possui", "arruda", "chain", "henrique", "web", "of", "science", "scopus", "spell", "freitas", "quanto", "neste", "dia", "londrina", "walter", "usa", "rodrigues", "daniel",
  "poitiers", "garrido", "marques", "ppgs", "saulo", 
  "ppgold", "jefferson", "desde", "paris", "bit", "aba",
  "aib", "pereira", "fernanda", "milton", "batista", 
  "mário", "serra", "lima", "ffia", "mpe", "gonçalves",
  "upm", "rafael", "atual", "amal", "alessandra", "gabriel",
  "degli", "cabral", "ditação", "porto", "patrícia", "viana",
  "bem", "índex", "index", "org", "curitiba", "graziela",
  "sido", "melo", "gomes", "lunkes", "joão", "título",
  "leonardo", "itajaí", "mateus", "andrade", "cristiane",
  "claudia", "cefet", "moc", "cesar", "dois", "pedron",
  "grenoble", "ribeiro", "além", "edson", "belo", 
  "horizente", "patrus", "pessoa", "fabiano", "luis",
  "cunha", "des", "junior", "araújo", "ribeirão",
  "sales",
  
  # SIGLAS removidas em 30/01/2026
  "puc-rio","puc-rio","unifaccamp","fgv-sp","mackenzie","fgv-sp","usp-rp","mackenzie","fucape","ufrpe","ufrj","unesa","pucrs","ufscar","ufsc","espm","usp","fgv-rj","fgv-rj", "fjp","fgv-rj","unifor","usp","unifor","udesc","puc-sp","udesc","unoesc","fgv-sp","unoesc","uff","fecap","uam","uff","unimep","unimep","unp","ufsc","unp","univali","cefet-mg","fecap","unialfa","uniesp","ibmec","unisinos","ucs","espm","atitus", "fpl","upf","ufpr","insper","puc-mg","usp-rp","puc-sp","pucpr","unama","unb", "furb","unb","ucs","unisc","usp","uerj","usp-esalq","unc","unigranrio","unisul",
  "univali","unisinos","unicamp-limeira","ufba","ufmg","uel","ufrn","uem","mackenzie","ufpe","fgv-eaesp","fucape","ufc","uece","unicentro","ufc","unioeste","unesp-jaboticabal","ufba","ufba","ufes","ufpb","ufcg","ufg","ufes","ufsm","unifei",
  "ufjf","ufla","ufrn","ufms","ufmg","ufpe","unir","ufsc","ufla","ufsm","ufs","ufu","ufv","ufes","unipampa","ufpr","usp","ufpa","ufpr","ufu","ufrj","furg","ufrn","unb","ufrgs","ufersa","feevale","fumec","uem","ufpel","usp","andifes","uscs","unb","uninove","unip","ufrn","up","furb","unifacs","ufrpe","unioeste","ufpb",
  "fucape","utfpr","fipecafi","unib","univali","uff","fdc","unochapecó","pucpr","ufal","idp","ifs","ufvjm","fia","ufpr","uninove","upe","ufpb","ufg","ufrgs", "ufrrj","usp","fucape","unisinos","ufms","ufpe","furg","uam","ufpb","uninove","fbv","insper","iesb","uri","fgv-sp","uerj","ufu","ufsm","fgv-sp","ufpe","ufsm","ufsc", "ufba","ufpb", "esag", "mpgeo", 
   

  # 3. Termos da Área (Se tudo é adm, remova 'administração' para ver os subtemas)
  "administração", "administracao", "gestão", "gestao", "business", "management", "pos", "pós", "graduação", "graduacao", "curso", "programa",
  
  # 4. Termos Genéricos dos Relatórios
  "trabalho", "evento", "eventos", "participação", "participacao",
  "social", "classificado", "português", "portugues",
  "revista", "tabela", "quadro", "figura", "dados", "analise",
  "geral", "forma", "parte", "grande", "objetivo", "resultado",
  "ano", "anos", "periodo", "relacao", "http", "https", "www", "index", "dr", "dra", "google", "acadêmico"
)

# REAPLICAR A LIMPEZA NO CORPUS
# Rode estas linhas novamente para efetivar a limpeza com a nova lista
corpus <- tm_map(corpus, removeWords, minhas_stopwords)
corpus <- tm_map(corpus, stripWhitespace)

#
# 5. GERAR MATRIZ DOCUMENTO-TERMO (DTM) ====
#
# Cria a matriz matemática
dtm <- DocumentTermMatrix(corpus)

# REMOÇÃO DE DOCUMENTOS VAZIOS
# Se a limpeza for muito agressiva, alguns documentos podem ficar zerados. O LDA trava se houver linhas vazias.
rowTotals <- apply(dtm , 1, sum) 
dtm_limpa <- dtm[rowTotals > 0, ]

print(paste("Documentos restantes após limpeza:", nrow(dtm_limpa)))

#
# 5.1 TUNING: DECIDINDO O NÚMERO IDEAL DE TÓPICOS (PERPLEXIDADE) ====
#

library(topicmodels)
library(ggplot2)

# Vamos testar de 2 a 12 tópicos (pode aumentar se quiser, mas demora mais)
range_k <- 2:20

# Vetor para guardar os valores
valores_perplexidade <- c()

print("Iniciando o teste de Perplexidade...")

for (k in range_k) {
  # Treina um modelo rápido para teste
  # iter = 100 é pouco para o modelo final, mas serve para o teste ser rápido
  modelo_teste <- LDA(dtm_limpa, k = k, method = "Gibbs", 
                      control = list(seed = 1234, iter = 100)) 
  
  # Calcula a perplexidade
  p <- perplexity(modelo_teste, dtm_limpa)
  valores_perplexidade <- c(valores_perplexidade, p)
  
  print(paste("K =", k, "| Perplexidade =", round(p, 2)))
}

#
# 5.2 VISUALIZAR A CURVA DE DECISÃO ====
#
df_tuning <- data.frame(k = range_k, perplexidade = valores_perplexidade)

ggplot(df_tuning, aes(x = k, y = perplexidade)) +
  geom_line(color = "darkblue", size = 1) +
  geom_point(color = "red", size = 3) +
  scale_x_continuous(breaks = range_k) +
  labs(title = "Escolha do Número de Tópicos",
       subtitle = "Procure o ponto onde a curva para de cair bruscamente (Cotovelo)",
       x = "Number of topics (K)",
       y = "Perplexity") +
  theme_minimal()

#
# 6. RODAR O MODELO LDA ====
#
# Defina o número de tópicos (k)
k_topicos <- 14

print("Treinando modelo LDA...")
lda_model <- LDA(dtm_limpa, k = k_topicos, method = "Gibbs", 
                 control = list(seed = 1234, iter = 2000)) # iter=2000 garante melhor convergência

#
# 7. ANÁLISES ====
#
# Extrai as palavras (tokens) e suas probabilidades (beta)
topicos_tabela <- tidy(lda_model, matrix = "beta")

# Pega as 10 palavras mais fortes de cada tópico para plotar
top_terms <- topicos_tabela %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

# Gera o gráfico geral
print(
  top_terms %>%
    mutate(term = reorder_within(term, beta, topic)) %>%
    ggplot(aes(term, beta, fill = factor(topic))) +
    geom_col(show.legend = FALSE) +
    facet_wrap(~ topic, scales = "free") +
    coord_flip() +
    scale_x_reordered() +
    labs(title = "Tópicos Identificados (LDA em R)",
         subtitle = "Palavras mais frequentes por tópico",
         x = NULL, y = "Importância (Beta)") +
    theme_minimal()
)

## TOPICS SEPARADOS 1-7 E 8-14 ====
# 1. PREPARAÇÃO DOS DADOS (Seu código original)
topicos_tabela <- tidy(lda_model, matrix = "beta")

top_terms <- topicos_tabela %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

# ===
# DEFININDO 14 CORES MANUALMENTE PARA MÁXIMO CONTRASTE
# ===
cores_manuais <- c(
  "#E41A1C", # 1. Vermelho Forte
  "#377EB8", # 2. Azul Forte
  "#4DAF4A", # 3. Verde Folha
  "#984EA3", # 4. Roxo
  "#FF7F00", # 5. Laranja Vivo
  "#ffee33", # 6. Amarelo (Cuidado: é claro, mas distinto)
  "#A65628", # 7. Marrom
  "#F781BF", # 8. Rosa
  "#999999", # 9. Cinza
  "#00CED1", # 10. Turquesa Escuro
  "#800000", # 11. Vinho/Bordeaux
  "#000080", # 12. Azul Marinho
  "#006400", # 13. Verde Escuro
  "#DAA520"  # 14. Dourado/Mostarda
)

# Trava as cores aos tópicos 1 a 14
names(cores_manuais) <- as.character(1:14)

# ===
# FIGURA A: TÓPICOS 1 A 7 (Cores 1 a 7)
# ===

dados_figura_A <- top_terms %>% filter(topic <= 7)

plot_A <- dados_figura_A %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free", ncol = 2) +
  coord_flip() +
  scale_x_reordered() +
  
  # Usa nossas cores manuais
  scale_fill_manual(values = cores_manuais) + 
  
  labs(title = "Tópicos Identificados (Parte 1/2)",
       subtitle = "Tópicos 1 a 7",
       x = NULL, y = "Importância (Beta)") +
  theme_minimal(base_size = 14)

ggsave("Figura_2A_AltoContraste.png", plot = plot_A, width = 10, height = 12, dpi = 300)
print(plot_A)

# ===
# FIGURA B: TÓPICOS 8 A 14 (Cores 8 a 14)
# ===

dados_figura_B <- top_terms %>% filter(topic >= 8)

plot_B <- dados_figura_B %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free", ncol = 2) +
  coord_flip() +
  scale_x_reordered() +
  
  # O tópico 8 vai pegar a cor Rosa, o 9 Cinza, etc... automaticamente
  scale_fill_manual(values = cores_manuais) + 
  
  labs(title = "Tópicos Identificados (Parte 2/2)",
       subtitle = "Tópicos 8 a 14",
       x = NULL, y = "Importância (Beta)") +
  theme_minimal(base_size = 14)

ggsave("Figura_2B_AltoContraste.png", plot = plot_B, width = 10, height = 12, dpi = 300)
print(plot_B)

###
## SAÍDAS EXTRAS ====

# 1. Recuperar quais documentos sobreviveram à limpeza (evita erro de índice)
indices_sobreviventes <- as.integer(rownames(dtm_limpa))

# 2. Filtrar os dados originais para alinhar com o modelo
dados_finais <- dados_limpos %>%
  slice(indices_sobreviventes) %>%
  mutate(document_id = as.character(indices_sobreviventes))

# 3. Extrair probabilidades do novo modelo (K=10)
lda_gamma <- tidy(lda_model, matrix = "gamma")

# 4. Criar o objeto 'dados_graficos'
dados_graficos <- lda_gamma %>%
  inner_join(dados_finais, by = c("document" = "document_id"))

print("✅ Objeto 'dados_graficos' recriado com sucesso!")

##
## PLOT - INSTITUIÇÃO POR TÓPICO ====
# 1. Extrair a probabilidade de cada documento pertencer a cada tópico (Gamma)
lda_gamma <- tidy(lda_model, matrix = "gamma")

# 2. ALINHAMENTO SEGURO (A correção do erro anterior)
# O LDA usa o nome da linha da DTM como ID. Vamos garantir que isso vire número.
lda_gamma$document_id <- as.integer(lda_gamma$document)

dados_graficos %>%
  # Agrupa por Tópico e Instituição
  group_by(topic, instituicao) %>%
  summarise(relevancia_media = mean(gamma), .groups = "drop") %>%
  # Pega apenas as Top 5 instituições de cada tópico para não poluir
  group_by(topic) %>%
  top_n(5, relevancia_media) %>%
  ungroup() %>%
  mutate(instituicao = reorder_within(instituicao, relevancia_media, topic)) %>%
  
  # Plot
  ggplot(aes(x = instituicao, y = relevancia_media, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free_y") + # Separa um gráfico por tópico
  coord_flip() + # Deita as barras para ler os nomes
  scale_x_reordered() +
  labs(title = "Quais Instituições focam em qual Tópico?",
       x = NULL,
       y = "Relevância Média do Tópico") +
  theme_bw()

############# MAPA DE CALOR (HEATMAP) ====

# Preparar dados: Média de relevância de cada tópico por instituição
heatmap_data <- dados_graficos %>%
  group_by(instituicao, topic) %>%
  summarise(forca_topico = mean(gamma), .groups = "drop")

# Plotar
ggplot(heatmap_data, aes(x = factor(topic), y = instituicao, fill = forca_topico)) +
  geom_tile(color = "white") + # Cria os quadradinhos
  # Usa uma escala de cor (Azul claro -> Azul escuro)
  scale_fill_gradient(low = "#f7fbff", high = "#08306b") +
  labs(title = "Mapa de Calor: Foco das Instituições",
       subtitle = "Intensidade de cada tópico por Programa/Instituição",
       x = "Tópico (Assunto)",
       y = NULL,
       fill = "Relevância") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 9)) # Ajuste o tamanho da letra se houver muitas faculdades

## HEATMAP COM 2 FIGURAS====
# --- 1. DADOS (Mantendo sua lógica exata) ---
heatmap_data <- dados_graficos %>%
  group_by(instituicao, topic) %>%
  summarise(forca_topico = mean(gamma), .groups = "drop")

heatmap_data_filtrado <- heatmap_data %>%
  group_by(topic) %>%
  slice_max(forca_topico, n = 3) %>% 
  ungroup() %>%
  mutate(instituicao = str_wrap(instituicao, width = 30))

# --- CORES (Mantendo consistência) ---
cores_manuais <- c(
  "#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00", "#ffee33", "#A65628",
  "#F781BF", "#999999", "#00CED1", "#800000", "#000080", "#006400", "#DAA520"
)
names(cores_manuais) <- as.character(1:14)


# ===
# FIGURA A: TÓPICOS 1 A 7 (CORRIGIDA)
# ===

plot_A <- heatmap_data_filtrado %>%
  filter(topic <= 7) %>%
  mutate(instituicao = reorder_within(instituicao, forca_topico, topic)) %>%
  
  ggplot(aes(x = forca_topico, y = instituicao, fill = factor(topic))) +
  geom_col(show.legend = FALSE, width = 0.7) +
  
  # --- CORREÇÃO AQUI: scales = "free" (Libera X e Y) ---
  # Agora cada gráfico terá sua própria escala de tamanho de barra
  facet_wrap(~ topic, scales = "free", ncol = 2) + 
  
  # ADIÇÃO: Coloca o valor numérico na frente da barra para conferência
  geom_text(aes(label = round(forca_topico, 3)), 
            hjust = -0.1, size = 3.5, fontface = "bold", color = "black") +
  
  scale_y_reordered() + 
  scale_fill_manual(values = cores_manuais) + 
  
  # Aumentei a expansão para 20% para caber o número escrito
  scale_x_continuous(expand = expansion(mult = c(0, 0.2))) +
  
  labs(title = "Instituições Líderes (Parte 1/2)",
       subtitle = "Tópicos 1 a 7: Média Gamma (Escalas independentes)",
       x = "Média de Aderência (Gamma)", y = NULL) +
  
  theme_minimal(base_size = 14) +
  theme(
    strip.text = element_text(face = "bold", size = 12),
    panel.grid.major.y = element_blank(),
    axis.text.y = element_text(size = 11, lineheight = 0.8)
  )

ggsave("Figura_Instituicoes_1-7_Final.png", plot = plot_A, width = 12, height = 12, dpi = 300)
print(plot_A)


# ===
# FIGURA B: TÓPICOS 8 A 14 (CORRIGIDA)
# ===

plot_B <- heatmap_data_filtrado %>%
  filter(topic >= 8) %>%
  mutate(instituicao = reorder_within(instituicao, forca_topico, topic)) %>%
  
  ggplot(aes(x = forca_topico, y = instituicao, fill = factor(topic))) +
  geom_col(show.legend = FALSE, width = 0.7) +
  
  # --- CORREÇÃO AQUI: scales = "free" ---
  facet_wrap(~ topic, scales = "free", ncol = 2) + 
  
  # ADIÇÃO: Valor numérico
  geom_text(aes(label = round(forca_topico, 3)), 
            hjust = -0.1, size = 3.5, fontface = "bold", color = "black") +
  
  scale_y_reordered() + 
  scale_fill_manual(values = cores_manuais) + 
  scale_x_continuous(expand = expansion(mult = c(0, 0.2))) +
  
  labs(title = "Instituições Líderes (Parte 2/2)",
       subtitle = "Tópicos 8 a 14: Média Gamma (Escalas independentes)",
       x = "Média de Aderência (Gamma)", y = NULL) +
  
  theme_minimal(base_size = 14) +
  theme(
    strip.text = element_text(face = "bold", size = 12),
    panel.grid.major.y = element_blank(),
    axis.text.y = element_text(size = 11, lineheight = 0.8)
  )

ggsave("Figura_Instituicoes_8-14_Final.png", plot = plot_B, width = 12, height = 12, dpi = 300)
print(plot_B)

########### NUVEM DE PALAVRAS ====
library(wordcloud)
library(reshape2)
library(RColorBrewer)

## GRAFO DE CONEXÕES (REDES) ====
library(ggraph)
library(igraph)

# 1. Pegar as palavras mais fortes (Beta)
top_termos_rede <- tidy(lda_model, matrix = "beta") %>%
  group_by(topic) %>%
  top_n(7, beta) %>% 
  ungroup() %>%
  arrange(topic, -beta)

# 2. Criar estrutura de grafo (Origem -> Destino)
# O tópico deve ser convertido para caracter para evitar confusão de tipos
arestas <- top_termos_rede %>%
  mutate(from = as.character(topic), to = term) %>%
  select(from, to)

# 3. Criar o objeto de grafo
grafo <- graph_from_data_frame(arestas, directed = FALSE)

# Precisamos acessar V(grafo)$name para ler os nomes dos nós.
# Também comparamos com as.character(1:k_topicos) para garantir que estamos comparando texto com texto.
V(grafo)$Legenda <- ifelse(V(grafo)$name %in% as.character(1:k_topicos), "Tópico", "Palavra")

# Define tamanhos fixos para plotar
# Se for tópico dá tamanho 10, se for palavra dá tamanho 3
V(grafo)$tamanho <- ifelse(V(grafo)$Legenda == "Tópico", 10, 3)

# 4. Plotar a Teia (Visual Ajustado)
ggraph(grafo, layout = "dh") + # Layout original mantido
  geom_edge_link(alpha = 0.2, color = "gray50") + 
  
  # Desenha os pontos (Nós)
  geom_node_point(aes(color = Legenda, size = tamanho), show.legend = TRUE) +
  
  # Desenha os textos com a NOVA identidade visual
  geom_node_text(aes(label = name), 
                 repel = TRUE, 
                 size = 3.8,
                 fontface = "bold",
                 # --- Visual Clean ---
                 bg.color = "white",       # Borda branca na letra
                 bg.r = 0.10,              # Espessura da borda
                 min.segment.length = Inf, # REMOVE as setas/linhas puxadas
                 max.overlaps = Inf) +     # Força aparecer o texto
  
  # Configurações visuais manuais (Novas Cores)
  scale_color_manual(values = c("Palavra" = "#69b3a2",   # Verde Água
                                "Tópico" = "#E76F51")) + # Terracota
  
  scale_size_identity() + # Usa o tamanho exato definido
  
  theme_void() +
  labs(title = "Rede de Conexões Semânticas")#,
  #subtitle = "Nós Terracota = Tópicos | Nós Verde água = Palavras Conectadas")

####### REDE C/ PALAVRAS COMPARTILHADAS DESTACADAS ====
# 1. Pegar as palavras mais fortes (Beta)
top_termos_rede <- tidy(lda_model, matrix = "beta") %>%
  group_by(topic) %>%
  top_n(7, beta) %>% 
  ungroup() %>%
  arrange(topic, -beta)

# 2. Criar estrutura de grafo (Origem -> Destino)
# O tópico deve ser convertido para caracter para evitar confusão de tipos
arestas <- top_termos_rede %>%
  mutate(from = as.character(topic), to = term) %>%
  select(from, to)

# 3. Criar o objeto de grafo
grafo <- graph_from_data_frame(arestas, directed = FALSE)

# --- ALTERAÇÃO AQUI (Lógica visual) ---
# Primeiro verificamos se é Tópico. 
# Se não for, verificamos o grau (degree): se > 1 é "Compartilhada", senão é "Palavra"
V(grafo)$Legenda <- case_when(
  V(grafo)$name %in% as.character(1:k_topicos) ~ "Tópico",
  degree(grafo) > 1 ~ "Compartilhada",
  TRUE ~ "Palavra"
)

# Define tamanhos fixos para plotar
# Tópico = 10, Compartilhada = 6 (destaque), Palavra = 3
V(grafo)$tamanho <- case_when(
  V(grafo)$Legenda == "Tópico" ~ 10,
  V(grafo)$Legenda == "Compartilhada" ~ 6, 
  TRUE ~ 3
)

# 4. Plotar a Teia (Visual Ajustado)
ggraph(grafo, layout = "dh") + # Layout original mantido
  geom_edge_link(alpha = 0.2, color = "gray50") + 
  
  # Desenha os pontos (Nós)
  geom_node_point(aes(color = Legenda, size = tamanho), show.legend = TRUE) +
  
  # Desenha os textos com a NOVA identidade visual
  geom_node_text(aes(label = name), 
                 repel = TRUE, 
                 size = 3.8,
                 fontface = "bold",
                 # --- Visual Clean ---
                 bg.color = "white",       # Borda branca na letra
                 bg.r = 0.07,              # Espessura da borda
                 min.segment.length = Inf, # REMOVE as setas/linhas puxadas
                 max.overlaps = Inf) +     # Força aparecer o texto
  
  # Configurações visuais manuais (ADICIONADA A COR "COMPARTILHADA")
  scale_color_manual(values = c("Palavra" = "#8c8c8c",       
                                "Compartilhada" = "#515cab", 
                                "Tópico" = "#203367")) +    
  
  scale_size_identity() + # Usa o tamanho exato definido
  
  theme_void() +
  labs(title = "Rede de Conexões Semânticas")

## ANALISAR CADA TERMO INDIVIDUALMENTE ESTILO IRAMUTEQ ====
# 1. Carregue a função de busca (se ainda não tiver carregado)
library(stringr)
library(dplyr)
library(tidyr)
library(DT)

analisar_termo <- function(termo_busca, dados, tamanho_janela = 80) {
  termo_regex <- regex(termo_busca, ignore_case = TRUE)
  
  resultado <- dados %>%
    filter(str_detect(texto, termo_regex)) %>%
    mutate(
      trecho = str_extract_all(
        texto, 
        paste0(".{0,", tamanho_janela, "}", termo_busca, ".{0,", tamanho_janela, "}")
      )
    ) %>%
    unnest(trecho) %>%
    select(instituicao, trecho)
  
  datatable(resultado, 
            options = list(pageLength = 10, searchHighlight = TRUE),
            caption = paste("Ocorrências de:", termo_busca),
            rownames = FALSE)
}

# Agora use os termos dos relatórios 
analisar_termo("capes", dados_trabalho)

#EXPORTAR OS DADOS POR TERMO ESTILO IRAMUTEQ ====
# Extrai os 5 termos mais fortes de cada tópico do seu modelo
matriz_termos <- terms(lda_model, 5) 

# Transforma em uma lista única e remove repetições
lista_de_termos <- unique(as.vector(matriz_termos))
# opção B: FAZER A PRÓPRIA LISTA MANUAL
#lista_de_termos <- c("impacto", "social", "mercado", "inovação", "extensão", "sustentabilidade")

print(lista_de_termos) # Veja a lista que ele gerou

library(stringr)
library(dplyr)
library(tidyr)
library(readr)

# --- 1. CAMINHO --- #alterar caminho para o da sua máquina - SALVA OS DADOS DO PASSO ANTERIOR
caminho_projeto <- "C:/Users/cesar/Downloads/Projeto_Impacto"
pasta_saida <- file.path(caminho_projeto, "Resultados_Consulta_Termos")

if (!dir.exists(pasta_saida)) {
  dir.create(pasta_saida, recursive = TRUE)
}

# 2. FUNÇÃO CORRIGIDA PARA ACENTOS
salvar_concordancia <- function(termo_busca, dados) {
  
  # A. Limpeza APENAS para o nome do arquivo
  termo_nome_arquivo <- iconv(termo_busca, to = "ASCII//TRANSLIT") 
  termo_nome_arquivo <- str_remove_all(termo_nome_arquivo, "[^a-zA-Z0-9]")
  
  nome_arquivo <- file.path(pasta_saida, paste0("termo_", termo_nome_arquivo, ".csv"))
  
  # B. Busca no texto (mantendo acentos originais)
  termo_regex <- regex(termo_busca, ignore_case = TRUE)
  
  resultado <- dados %>%
    filter(str_detect(texto, termo_regex)) %>%
    mutate(
      trecho = str_extract_all(
        texto, 
        # Pega o contexto. O ponto (.) no R já pega letras acentuadas.
        paste0(".{0,300}", termo_busca, ".{0,300}") 
      )
    ) %>%
    unnest(trecho) %>%
    select(instituicao, trecho)
  
  # C. SALVAMENTO CORRIGIDO
  if(nrow(resultado) > 0) {
    # write_excel_csv2: Usa ponto-e-vírgula (;) e força o Excel a ler acentos
    write_excel_csv2(resultado, nome_arquivo)
    print(paste("Salvo:", basename(nome_arquivo)))
  }
}

# --- 3. EXECUTAR ---
print("Iniciando exportação com correção de acentos...")

for (palavra in lista_de_termos) {
  tryCatch({
    salvar_concordancia(palavra, dados_trabalho)
  }, error = function(e) {
    print(paste("ERRO em", palavra, ":", e$message))
  })
}

print("Finalizado!")


# ANÁLISES ADICIONAIS - HEATMAP INSTITUIÇÕES POR NOTA ====
# 1. Extrai a probabilidade de cada tópico por documento
matriz_gamma <- tidy(lda_model, matrix = "gamma")

# 2. Mapeamento super seguro dos IDs
# O 'document' no LDA corresponde ao número da linha do arquivo dados_limpos
doc_ids <- data.frame(
  document = rownames(dtm_limpa),
  id_original = dados_limpos$id[as.numeric(rownames(dtm_limpa))]
)

# 3. Une o gamma com o ID original
tabela_gammas <- matriz_gamma %>%
  left_join(doc_ids, by = "document")

# 4. Traz os metadados do JSON original (dados_raw)
tabela_final <- tabela_gammas %>%
  left_join(dados_raw, by = c("id_original" = "ID")) %>%
  
  # Limpa o texto da modalidade para o gráfico ficar bonito
  mutate(Modalidade_Clean = case_when(
    str_detect(Modalidade, "Aca") ~ "Academic",
    str_detect(Modalidade, "Prof") ~ "Professional",
    TRUE ~ "Outros"
  ))

print("Tabela mestra criada com sucesso!")

# análise  1 - acad. vs prof.
# Calcula média por Modalidade
resumo_modalidade <- tabela_final %>%
  filter(!is.na(Modalidade_Clean)) %>%
  group_by(Modalidade_Clean, topic) %>%
  summarise(gamma_medio = mean(gamma, na.rm = TRUE), .groups = "drop")

# ANÁLISE 2 - NOTA VS MODALIDADE HEATMAP
# Primeiro, filtramos o tópico 10 da base de resumo
resumo_modalidade_filtrado <- resumo_modalidade %>%
  filter(topic != 10)

# Gráfico de Barras Comparativo ACA X PROF por tópico
ggplot(resumo_modalidade_filtrado, aes(x = factor(topic), y = gamma_medio, fill = Modalidade_Clean)) +
  geom_col(position = "dodge") + # Coloca as barras lado a lado
  scale_fill_manual(values = c("Academic" = "#203367", "Professional" = "#8fb6d8")) +
  labs(title = "Perfil de Impacto: Acadêmico vs. Profissional",
       subtitle = "Comparação da força média de cada tópico (Tópico 10 removido para ajuste de escala)",
       x = "Tópico", 
       y = "Força Média (Gamma)",
       fill = "Modalidade") +
  theme_minimal() +
  theme(
    legend.position = "top",
    plot.background = element_rect(fill = "white", color = NA) # Garante fundo branco sólido
  )

# Concentração temática por nota da capes
# Adicionamos a condição topic != 10 direto no filtro inicial
resumo_nota_mod <- tabela_final %>%
  filter(!is.na(`Nota da Avaliação`), !is.na(Modalidade_Clean), topic != 10) %>% 
  group_by(`Nota da Avaliação`, Modalidade_Clean, topic) %>%
  summarise(gamma_medio = mean(gamma, na.rm = TRUE), .groups = "drop")

# Gráfico de Concentração (Heatmap)
ggplot(resumo_nota_mod, aes(x = factor(`Nota da Avaliação`), y = factor(topic), fill = gamma_medio)) +
  geom_tile(color = "white", linewidth = 0.5) +
  scale_fill_gradient(low = "#f4f2f2", high = "#203367", name = "Gamma") +
  facet_wrap(~ Modalidade_Clean, scales = "free_x") + # Divide o gráfico em dois!
  labs(title = "Concentração Temática por Nota da CAPES",
       subtitle = "Diferenças de discurso entre programas (Tópico 10 removido para ajuste de escala)",
       x = "Evaluation Score (CAPES)", 
       y = "Topic") +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    plot.background = element_rect(fill = "white", color = NA) # Garante fundo branco sólido
  )