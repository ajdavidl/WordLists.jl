using WordLists
using Test

@testset "Does not explode" begin
    @test words("english") isa Vector{String}
end

@testset "Case insensitive" begin
    @test words("english") == words("eNGliSh")
end

@testset "Non-english languages" begin
    @test words("spanish") isa Vector{String}
    @test words("portuguese") isa Vector{String}
    @test words("french") isa Vector{String}
    @test words("italian") isa Vector{String}
    @test words("german") isa Vector{String}
    @test words("dutch") isa Vector{String}
end

@testset "Aliases" begin
    @test words("english") == words("en") == words("eng")
    @test words("spanish") == words("es") == words("spa") == words("español")
    @test words("portuguese") == words("pt") == words("por") == words("português")
    @test words("french") == words("fr") == words("fre") == words("fra") == words("français")
    @test words("italian") == words("it") == words("ita") == words("italiano")
    @test words("german") == words("de") == words("deu") == words("deutsch")
    @test words("dutch") == words("nl") == words("nld") == words("nederlands")
end

@testset "Duplicate removal" begin
    @test words("english") == words("english", "en", "eng")
end

@testset "All" begin
    @test words("english") ⊆ words("english"; all=true)
    @test length(words("english")) < length(words("english"; all=true))
    @test words("spanish") == words("spanish"; all=true) # handle missing extra.txt
    @test words("portuguese") == words("portuguese"; all=true)
    @test words("french") == words("french"; all=true)
    @test words("italian") == words("italian"; all=true)
    @test words("german") == words("german"; all=true)
    @test words("dutch") == words("dutch"; all=true)
end

@testset "Multilingual" begin
    @test words("en") ⊊ words("english", "spanish", "portuguese", "french", "italian", "german", "dutch")
end

@testset "Error messages" begin
    @test_throws ArgumentError("No languages specified. Try `words(\"español\")`.") words()
    @test_throws ArgumentError("Unknown language code: foo") words("foo")
end

@testset "Content" begin
    @testset "Formatting" begin
        for langs in [("english",), ("spanish",), ("portuguese",), ("french",), ("italian",), ("german",), ("dutch",), ("english", "spanish", "portuguese", "french", "italian", "german", "dutch")], all in [false, true]
            list = words(langs...; all)
            @test issorted(list)
            @test !any(word -> any(isspace, word), list) # No word contains whitespace
            @test allunique(list)
        end
    end

    @testset "English Content" begin
        en = words("en")
        aen = words("en"; all=true)

        @test "hello" ∈ en
        @test "cookie" ∈ en
        @test "cookiemonster" ∉ en
        @test "supercalifragilisticexpialidocious" ∉ en
        @test "ljkaflkj" ∉ en

        @testset "All" begin
            @test "hello" ∈ aen
            @test "cookie" ∈ aen
            @test "cookiemonster" ∈ aen
            @test "supercalifragilisticexpialidocious" ∈ aen
            @test "ljkaflkj" ∉ aen
        end

        @testset "length" begin
            @test 100_000 < length(en) < length(aen) < 1_000_000
        end
    end

    @testset "Spanish Content" begin
        es = words("es")
        for word in ["a", "ser", "estar", "hola", "bienvenidos", "levántate", "pelota",
            "cabezas", "idioma", "español"]
            @test word ∈ es
        end
        for word in ["levantate", "hi", "orange", "pear", "lkfjakljf", "the", "of",
            "and", "to", "it", "with", "for", "on", "his", "that", "this", "have", "from",
            "by", "was", "were", "são", "estão"]
            @test word ∉ es
        end
    end

    @testset "Portuguese Content" begin
        pt = words("pt")
        for word in ["a", "ser", "estar", "olá", "bem", "levantar", "bolota", "cometa",
            "cabeças", "idioma", "espanhol", "amor", "de", "isso", "isto", "aquilo",
            "pregar", "orar", "pelejar", "caminhar", "falar", "palavra", "família",
            "cafuné", "contêm", "desbundar", "lavagem", "xodó"]
            @test word ∈ pt
        end
        for word in ["levantate", "hi", "orange", "bear", "lkfjakljf", "the", "ofset",
            "und", "toll", "its", "with", "forza", "onto", "his", "that", "this", "have", "from",
            "by", "was", "were"]
            @test word ∉ pt
        end
    end

    @testset "French Content" begin
        fr = words("fr")
        for word in ["merci", "français", "fille", "garçon", "beau", "belle", "jour",
            "demain", "amour", "pas", "je", "ne", "plus", "petit", "grand",
            "désolé", "comme", "son", "il", "était", "sur", "sont", "avec"]
            @test word ∈ fr
        end
        for word in ["levantate", "hi", "pear", "lkfjakljf", "the", "of",
            "and", "to", "it", "with", "his", "that", "this", "from",
            "by", "was", "were", "são", "estão"]
            @test word ∉ fr
        end
    end

    @testset "Italian Content" begin
        it = words("it")
        for word in ["grazie", "italiana", "ragazza", "bambino", "bella", "vero",
            "giorno", "domani", "amore", "ci", "ne", "non", "più", "piccolo",
            "grande", "scusa", "mi", "piace", "suo", "lui", "era", "su", "sono"]
            @test word ∈ it
        end
        for word in ["levantate", "hi", "pear", "lkfjakljf", "the", "of",
            "and", "to", "it", "with", "his", "that", "this", "from",
            "by", "was", "were", "são", "estão", "avec"]
            @test word ∉ it
        end
    end

    @testset "German Content" begin
        de = words("de")
        for word in ["können", "dürfen", "mögen", "ich", "bin", "müssen", "Frau",
            "sollen", "haben", "sein", "wurden", "bis", "durch", "für", "morgen",
            "aus", "bevor", "wie", "ab", "Sie", "worauf", "du", "Tag", "was"]
            @test word ∈ de
        end
        for word in ["levantate", "pear", "lkfjakljf", "the", "of",
            "and", "to", "with", "that", "this", "from",
            "by", "were", "são", "estão", "avec"]
            @test word ∉ de
        end
    end

    @testset "Dutch Content" begin
        nl = words("nl")
        for word in ["ik", "heet", "ben", "een", "de", "het", "man", "vrouw", "jongen",
            "meisje", "huis", "hallo", "hoi", "goed", "slecht", "morgen", "goedenavond",
            "alsjeblieft", "wij", "we", "jullie", "zij", "u", "sterk", "bijzonder"]
            @test word ∈ nl
        end
        for word in ["levantate", "pear", "lkfjakljf", "the", "off", "soy",
            "and", "to", "with", "that", "this", "frau", "null", "hoy",
            "buy", "were", "são", "estão", "avec", "amore", "vida"]
            @test word ∉ nl
        end
    end
end
