#include <sodium.h>
#include <erl_nif.h>
#include <stdio.h>

static ERL_NIF_TERM tokenizer_seal(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    if (argc != 2) {
        return enif_make_badarg(env);
    }

    ErlNifBinary msg, seal_key, ct;

    if (!enif_inspect_binary(env, argv[0], &msg)) {
        if (!enif_inspect_iolist_as_binary(env, argv[0], &msg)) {
            printf("bad arg0\n");
            return enif_make_badarg(env);
        }
    }

    if (!enif_inspect_binary(env, argv[1], &seal_key)) {
        if (!enif_inspect_iolist_as_binary(env, argv[1], &seal_key)) {
            printf("bad arg1\n");
            return enif_make_badarg(env);
        }
    }
    if (seal_key.size != crypto_box_PUBLICKEYBYTES) {
        printf("bad arg1 len\n");
        return enif_make_badarg(env);
    }

    if (!enif_alloc_binary(crypto_box_SEALBYTES + msg.size, &ct)) {
        return enif_make_tuple2(env, enif_make_atom(env, "error"), enif_make_atom(env, "alloc"));
    }

    if (crypto_box_seal(ct.data, msg.data, msg.size, seal_key.data)) {
        enif_release_binary(&ct);
        return enif_make_tuple2(env, enif_make_atom(env, "error"), enif_make_atom(env, "seal"));
    }

    return enif_make_tuple2(env, enif_make_atom(env, "ok"), enif_make_binary(env, &ct));
}

static ErlNifFunc nif_funcs[] = {
    {"seal", 2, tokenizer_seal}
};

ERL_NIF_INIT(Elixir.Tokenizer.Nif, nif_funcs, NULL, NULL, NULL, NULL)