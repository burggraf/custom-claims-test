<script lang="ts">
    import { createClient, SupabaseClient } from '@supabase/supabase-js';
    import { PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_KEY } from '$env/static/public'
    import type { User } from '@supabase/supabase-js';
    import { writable } from 'svelte/store';
	import { onMount } from 'svelte'
    const supabase: SupabaseClient = createClient(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_KEY);
    const user: any = writable<User | null>(null);
    let email = '';
    let password = '';
    let claims: any = null;
    onMount(async () => {
        // const { data, error } = await supabase.rpc('get_my_other_claims');
        // console.log('get_my_other_claims', data, error);

        // const { data: data2, error: error2 } = await supabase.rpc('get_my_other_claims2');
        // console.log('get_my_other_claims2', data2, error2);
        // const { data: data3, error: error3 } = await supabase.rpc('get_my_claims');
        // console.log('get_my_claims', data3, error3);
    });
    const set_claims = async () => {
        const { data, error } = await supabase.rpc('get_my_other_claims');
        if (error) { console.error('set_claims error', error)}
        else {claims = data; console.log('claims', claims);}
    }
    supabase.auth.onAuthStateChange(async (event, session) => {
        console.log('onAuthStateChange', event, session)
        user.set(session?.user ?? null);
        set_claims();        
    });  

    const signin = async () => {
        const { data, error } = await supabase.auth.signInWithPassword({
            email,
            password,
        })
    }
    const signup = async () => {
        const { data, error } = await supabase.auth.signUp({
            email,
            password,
        })
    }
    const signout = async () => {
        const { error } = await supabase.auth.signOut();
    }
</script>
<h1>Test Custom Claims</h1>
{#if $user}
    <p>Logged in as {$user.email}</p>
    <button on:click={signout}>Logout</button>
{:else}
    <h2>Login</h2>
    <form>
    <table>
        <tr>
            <td>Email address</td>
            <td><input type="text" bind:value={email} /></td>
        </tr>
        <tr>
            <td>
                Password
            </td>
            <td>
                <input type="password" bind:value={password} />
            </td>
        </tr>
        <tr>
            <td>
                <button on:click={signin}>Login</button>
            </td>
        </tr>
        <tr>
            <td>
                <button on:click={signup}>Sign Up</button>
            </td>
        </tr>
    </table>
    </form>
{/if}

<br/><br/>claims:<pre>{JSON.stringify(claims, null, 2)}</pre>
$user:<pre>{JSON.stringify($user, null, 2)}</pre>
