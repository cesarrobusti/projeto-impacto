from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import Select
import time

# Configurar o WebDriver
options = Options()
options.add_argument("--start-maximized")
options.add_argument("--disable-extensions")
options.add_argument("--disable-gpu")
options.add_argument("--no-sandbox")

service = Service("chromedriver.exe")  # Caminho do ChromeDriver
driver = webdriver.Chrome(service=service, options=options)

# Acessar o site Sucupira Legado da CAPES
driver.get("https://sucupira-legado.capes.gov.br/sucupira/public/consultas/coleta/envioColeta/dadosFotoEnvioColeta.jsf")

# Criar espera explícita
wait = WebDriverWait(driver, 10)

def consultar_universidade(nome_universidade):
    try:
        print(f"\n🔍 Pesquisando: {nome_universidade}")

        # Selecionar "Coleta de Informações 2020"
        select_ano = wait.until(EC.element_to_be_clickable((By.ID, "form:j_idt33:calendarioid")))
        Select(select_ano).select_by_value("719")

        # Selecionar Instituição
        campo_inst = wait.until(EC.element_to_be_clickable((By.ID, "form:j_idt33:inst:input")))
        campo_inst.clear()
        campo_inst.click()
        time.sleep(1)  # Tempo para abrir a lista

        campo_inst.send_keys(nome_universidade)
        time.sleep(3)  # Tempo para carregar sugestões

        # Inicializa a variável 'select'
        select = None
        select_inst = wait.until(EC.presence_of_element_located((By.ID, "form:j_idt33:inst:listbox")))
        select = Select(select_inst)

        encontrou = False
        for option in select.options:
            if nome_universidade.lower() in option.text.lower():
                print(f"✅ Selecionando: {option.text}")
                select.select_by_visible_text(option.text)
                encontrou = True
                break

        if not encontrou:
            raise Exception("Instituição não encontrada na lista suspensa!")

        driver.execute_script("arguments[0].dispatchEvent(new Event('change'))", select_inst)
        time.sleep(2)  # Tempo para a seleção ser registrada

        # Selecionar "Administração" dentro da lista de programas
        # Alguns programas da área 27 da CAPES apresentam nomes diferentes, como: administração de empresas, ADMINISTRAÇÃO E DESENVOLVIMENTO, ADMINISTRAÇÃO PÚBLICA E GOVERNO, entre outros
        # Ou são divididos em profissional e acadêmico, esses programas, nesta versão do código, podem não ser capturados corretamente, vale realizar uma verificação manual após coleta
        # Se necessário, esses programas podem ser coletados ajustando abaixo para o nome do programa desejado
        select_programa = wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, "select[name='form:j_idt33:j_idt406']")))
        select_prog = Select(select_programa)

        encontrou_prog = False
        for option in select_prog.options:
           if "ADMINISTRAÇÃO" in option.text.upper():
                print(f"✅ Selecionando programa: {option.text}")
                select_prog.select_by_visible_text(option.text)
                encontrou_prog = True
                break

        if not encontrou_prog:
            raise Exception("Programa 'Administração' não encontrado na lista!")

        driver.execute_script("arguments[0].dispatchEvent(new Event('change'))", select_programa)
        time.sleep(2)  # Aguardar atualização

        # Clicar no botão "Consultar"
        botao_consultar = wait.until(EC.element_to_be_clickable((By.ID, "form:consultar")))
        print("🔎 Clicando no botão 'Consultar'...")
        botao_consultar.click()
        
        # Aguardar a requisição AJAX ser processada (esperar carregamento dos resultados)
        wait.until(EC.visibility_of_element_located((By.CLASS_NAME, "ui-outputtext")))
        print("✅ Consulta realizada com sucesso!")

        # Capturar e imprimir os resultados
        resultados = driver.find_elements(By.CLASS_NAME, "ui-outputtext")
        for resultado in resultados:
            print(resultado.text)

        print(f"✅ Pesquisa concluída para: {nome_universidade}")

    except Exception as e:
        print(f"❌ Erro ao consultar {nome_universidade}: {e}")

def expandir_e_baixar_proposta():
    try:
        # Localizar o botão de expansão da seção "Proposta"
        botaoExpandir = driver.find_element(By.CSS_SELECTOR, "div#proposta .panel-heading button[aria-expanded='false']")
        
        if botaoExpandir:
            # Verificar se a seção já está expandida
            estaExpandido = botaoExpandir.get_attribute("aria-expanded") == "true"
            if not estaExpandido:
                print("🔄 Expandindo a seção 'Proposta'...")
                # Usando JavaScript para clicar no botão e expandir a seção
                driver.execute_script("arguments[0].click();", botaoExpandir)
                time.sleep(5)  # Aguardar para garantir que a seção foi expandida
            else:
                print("ℹ️ A seção 'Proposta' já está expandida.")
        else:
            print("❌ Botão de expansão não encontrado.")

        # Aguardar a visibilidade do conteúdo da seção
        wait.until(EC.visibility_of_element_located((By.ID, "collapseProposta")))

        # Captura o nome da instituição selecionada
        nomeInstituicao = driver.find_element(By.ID, "form:j_idt33:inst:input").get_attribute("value") or "instituicao_desconhecida"
        
        # Captura todo o conteúdo da seção "Proposta"
        time.sleep(10)
        secaoProposta = driver.find_element(By.CSS_SELECTOR, "div#collapseProposta")
        if secaoProposta:
            textoProposta = secaoProposta.text.strip()
            if textoProposta:
                nomeArquivo = f"Proposta_{nomeInstituicao.replace(' ', '_')}.txt"
                with open(nomeArquivo, "w", encoding="utf-8") as f:
                    f.write(textoProposta)
                print(f"✅ Download do arquivo '{nomeArquivo}' realizado!")
            else:
                print("⚠️ A seção 'Proposta' está vazia.")
        else:
            print("❌ Seção 'Proposta' não encontrada.")
    except Exception as e:
        print(f"❌ Erro ao expandir e baixar a proposta: {e}")

# Lista de universidades para consulta
# Adicione outras instituições conforme necessário, usando sempre o nome presente nos "Dados Cadastrais do Programa" na plataforma Sucupira da CAPES
universidades = [
"UNIVERSIDADE DE SÃO PAULO",
"UNIVERSIDADE MUNICIPAL DE SÃO CAETANO DO SUL",
"UNIVERSIDADE FEDERAL DE SÃO PAULO",
]

# Função para consultar todas as universidades da lista
def consultar_todas_as_universidades(universidades):
    for universidade in universidades:
        # Consultar a universidade
        consultar_universidade(universidade)
        
        # Após a consulta, expandir a seção e baixar a proposta
        expandir_e_baixar_proposta()

# Chamar a função para consultar todas as universidades
consultar_todas_as_universidades(universidades)

# Fechar o navegador após todas as consultas
driver.quit()

