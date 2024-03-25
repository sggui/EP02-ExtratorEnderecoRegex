# Extrator de endereços
require 'open-uri' #para abrir URLs

class Extrator
  @tipo = ""      # Tipo do endereço (ex: rua, avenida)
  @nome = ""      # Nome do logradouro
  @nume = ""      # Número do endereço
  @comp = ""      # Complemento do endereço
  @bairro = ""    # Bairro
  @cidade = ""    # Cidade
  @estado = ""    # Estado
  @cep = ""       # CEP

  def initialize(input)
    @endereco = input

    # Valores padrão para as variáveis
    @tipo = "N/A"
    @nome = "N/A"
    @nume = "S/N"
    @comp = "N/A"
    @bairro = "N/A"
    @cidade = "N/A"
    @estado = "N/A"
    @cep = "N/A"
  end

  # remover pontuações no inicio da string
  def limparComeco(input)
    return input.to_s.gsub(/^(\.?\,?\-?\s?)/, "")
  end

  # extrair informações basicas do endereco
  def submatch
    regex = /^[A-Za-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ0-9\s\.]+( |\,) ?\d+(\w)?/
    sub = @endereco.match(regex).to_s
    @endereco = @endereco.gsub(regex, "")

    # extrair o tipo de logradouro
    regex = /(((A|a)venida|(A|a)v)|((R|r)odovia)|((R|r)ua|^(\s*(R|r)))|(E|e)strada|(T|t)ravessa)(\.)?(\s)/
    @tipo = sub.match(regex).to_s
    sub = sub.gsub(regex,"")

    # extrair o numero do endereco
    regex = /(\d+(\w)?)$/
    @nume = sub.match(regex).to_s
    sub = sub.gsub(regex, "")

    # extrair o nome do logradouro
    regex = /^[A-Za-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ0-9\s\.]+/
    @nome = sub.match(regex).to_s
    sub = sub.gsub(regex,"")
  end

  # extrair o complemento do endereço
  def complemento(input, regex)
    verif = input.match(/(bloco|bc|ap(to|artamento)|ala|andar|anexo|casa|cobertura|frente|fundos|port(a|ã)o|pr(e|é)dio|quadra|sala|sobrado|sobreloja|subsolo|t(e|é)rreo)+/i)
    if !verif.nil? && !verif.to_s.empty?
      if @comp.to_s != "Não se aplica"
        @comp = @comp + ", " + input
      else
        @comp = input
      end
      @endereco = @endereco.gsub(regex, "")
      return true
    end
    return false
  end

  # Método para extrair o bairro
  def bairro
    regex = /^[A-Za-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ0-9\s\.]+/i
    @endereco = limparComeco(@endereco)
    @bairro = @endereco.match(regex)
    @endereco = @endereco.gsub(regex, "")
    if @bairro.to_s.to_i != 0
      if @comp.to_s != "Não se aplica"
        @comp = @comp + ", " + @bairro.to_s
      else
        @comp = @bairro
      end
      bairro
    end
  end

  # Método para extrair a cidade
  def cidade
    regex = /^[A-Za-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ0-9\s\.]+/i
    @endereco = limparComeco(@endereco)
    @cidade = @endereco.match(regex)
    @endereco = @endereco.gsub(regex, "")
    if @cidade.nil? || @cidade.to_s.empty?
      @cidade = @bairro
      @bairro = "Não se aplica"
    end
  end