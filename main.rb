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