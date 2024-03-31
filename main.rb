#Extrator de endereços
require 'open-uri' #para abrir URLs

class Extrator
  @tipo = ""
  @nome = ""
  @nume = ""
  @comp = ""
  @bairro = ""
  @cidade = ""
  @estado = ""
  @cep = ""

  def initialize(input)
    @endereco = input

    @tipo = "N/A"
    @nome = "N/A"
    @nume = "S/N"
    @comp = "N/A"
    @bairro = "N/A"
    @cidade = "N/A"
    @estado = "N/A"
    @cep = "N/A"
  end

  # Pra tirar as pontuações aleatórias que sobram no começo da string dps do gsub
  def limparComeco(input)
    return input.to_s.gsub(/^(\.?\,?\-?\s?)/, "")
  end

  def submatch
    regex = /^[A-Za-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ0-9\s\.]+( |\,) ?\d+(\w)?/
    sub = @endereco.match(regex).to_s
    @endereco = @endereco.gsub(regex, "")

    regex = /(((A|a)venida|(A|a)v)|((R|r)odovia)|((R|r)ua|^(\s*(R|r)))|(E|e)strada|(T|t)ravessa)(\.)?(\s)/
    @tipo = sub.match(regex).to_s
    sub = sub.gsub(regex,"")

    regex = /(\d+(\w)?)$/
    @nume = sub.match(regex).to_s
    sub = sub.gsub(regex, "")

    regex = /^[A-Za-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ0-9\s\.]+/
    @nome = sub.match(regex).to_s
    sub = sub.gsub(regex,"")
  end

  def complemento(input, regex)
    verif = input.match(/(bloco|bc|ap(to|artamento)|ala|andar|anexo|casa|cobertura|frente|fundos|port(a|ã)o|pr(e|é)dio|quadra|sala|sobrado|sobreloja|subsolo|t(e|é)rreo)+/i)
    if !verif.nil? && !verif.to_s.empty?
      if @comp.to_s != "N/A"
        @comp = @comp + ", " + input
      else
        @comp = input
      end
      @endereco = @endereco.gsub(regex, "")
      return true
    end
    return false
  end

  def bairro
    regex = /^[A-Za-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ0-9\s\.]+/i
    @endereco = limparComeco(@endereco)
    @bairro = @endereco.match(regex)
    @endereco = @endereco.gsub(regex, "")
    if @bairro.to_s.to_i != 0
      if @comp.to_s != "N/A"
        @comp = @comp + ", " + @bairro.to_s
      else
        @comp = @bairro
      end
      bairro
    end
  end

  def cidade
    regex = /^[A-Za-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ0-9\s\.]+/i
    @endereco = limparComeco(@endereco)
    @cidade = @endereco.match(regex)
    @endereco = @endereco.gsub(regex, "")
    if @cidade.nil? || @cidade.to_s.empty?
      @cidade = @bairro
      @bairro = "N/A"
    end
  end

  def estado
    regex = /(AC|AL|AP|AM|BA|CE|DF|ES|GO|MA|MT|MS|MG|PA|PB|PR|PE|PI|RJ|RN|RS|RO|RR|SC|SP|SE|TO)/
    @estado = @endereco.match(regex)
    @endereco = @endereco.gsub(regex, "")
  end

  def cep
    regex = /\d{5}(-| )?\d{3}/
    @cep = @endereco.match(regex)
    if @cep.nil? || @cep.to_s.empty?
      @cep = "N/A"
    end
    @endereco = @endereco.gsub(regex, "")
  end

  def show
    puts "Tipo: " + @tipo.to_s
    puts "Nome: " + @nome.to_s
    puts "Numero: " + @nume.to_s
    puts "Complemento: " + @comp.to_s
    puts "Bairro: " + @bairro.to_s
    puts "Cidade: " + @cidade.to_s
    puts "Estado: " + @estado.to_s
    puts "CEP: " + @cep.to_s
  end

  def opcionais
    regexComp = /^[A-Za-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ0-9\s\.]+(?=\,|\-)/
    bat = true
    while bat
      @endereco = limparComeco(@endereco)
      novoScan = @endereco.match(regexComp)
      bat = complemento(novoScan.to_s, regexComp)
    end
    bairro
    cidade
  end

  def extract
    print("Endereço encontrado: ", @endereco, "\n")

    initial_matches = @endereco.scan(/[A-Za-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ0-9\s\.]+( |\,) ?\d+(\w)?/)
    initial_count = initial_matches.size

    submatch
    cep
    estado
    opcionais

    puts
    show

    final_matches = @endereco.scan(/[A-Za-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ0-9\s\.]+( |\,) ?\d+(\w)?/)
    final_count = final_matches.size

    removed_count = initial_count - final_count
    print("\nQtd matches removidos: #{removed_count}\n")
    print("matches removidos:\n", @endereco)
    end
  end

class Programa
  def iniciar
    puts "|---------------------|"
    puts "|   EP02 - LFA        |"
    puts "|                     |"
    puts "| Guilherme Guimarães |"
    puts "| &                   |"
    puts "| Gustavo Piroupo     |"
    puts "|---------------------|\n\n"
    puts "Escolha qual opção você quer usar no nosso projeto:"
    puts "1 - Ler uma URL pré-definida", "2 - Ler um texto pré-definido", "3 - Inserir um texto", "4 - Inserir uma URL"
    puts "Sua escolha: "
    while true
      escolha = gets.chomp
      case escolha.to_i
      when 1
        lerURI
        break
      when 2
        lerTexto
        break
      when 3
        usuarioInsereTxt
        break
      when 4
        usuarioInsereUrl
        break
      else
        puts "Selecione um valor válido:"
      end
    end
  end

  def lerURI
    system 'clear'
    puts "Escolha a URL que você gostaria de ler:"
    puts "1 - SENAC", "2 - Mini Carta 2", "3 - Nava Technology for Business", "4 - Shopping Leblon"
    puts "Selecione o número da sua escolha: "

    file = File.open("texto.txt")
    texto = file.readlines.map(&:chomp)
    link = ""
    while true
      escolha = gets.chomp
      case escolha.to_i
      when 1
        link = texto[5]
        break
      when 2
        link = texto[7]
        break
      when 3
        link = texto[9]
        break
      when 4
        link = texto[11]
        break
      else
        puts "Selecione um valor válido:"
      end
    end
    file.close
    uri = URI.parse(link)
    data = uri.read # string que contem todo o texto do site.
    extrair(data)
  end

  def lerTexto
    system 'clear'
    puts "O texto é o seguinte:"
    file = File.open("texto.txt")
    texto = file.readlines.map(&:chomp)
    file.close
    puts texto[0]
    puts texto[1]
    puts ""
    extrair(texto[1])
  end

  def usuarioInsereTxt
    system 'clear'
    puts "Por favor, insira seu texto (O endereço deve estar nesse formato: Rua|Avenida, nº - Bairro, Cidade - Estado (sigla), CEP (00000-000)):"
    texto = gets.chomp
    puts ""
    extrair(texto)
  end

  def usuarioInsereUrl
    system 'clear'
    puts "obs.: Pode não funcionar em todos os sites", "Por favor, insira seu link:"
    link = gets.chomp

    uri = URI.parse(link)
    data = uri.read # string que contem todo o texto do site.
    system 'clear'
    extrair(data)
  end

  def extrair(texto)
  regex = /\b(((A|a)venida|(A|a)v)|((R|r)odovia)|((R|r)ua|(R|r))|(E|e)strada|(T|t)ravessa)\.?\s([A-Za-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ0-9 \.\,\-\/\|\:]+)\s(((AC|AL|AP|AM|BA|CE|DF|ES|GO|MA|MT|MS|MG|PA|PB|PR|PE|PI|RJ|RN|RS|RO|RR|SC|SP|SE|TO))|(\d{5}(\-| )\d{3}))\b/

  textoR = texto.match(regex).to_s
  textoR = textoR.gsub(/>|</,"")
  endereco = Extrator.new(textoR)
  endereco.extract
  end
end

p = Programa.new
p.iniciar