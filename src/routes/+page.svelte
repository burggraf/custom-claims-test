<script lang="ts">
    import { createClient, SupabaseClient } from '@supabase/supabase-js';
    import { PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_KEY } from '$env/static/public'
    console.log('VITE_SUPABASE_URL', PUBLIC_SUPABASE_URL)
    //const VITE_SUPABASE_URL = import.meta.env.VITE_SUPABASE_URL
    //const VITE_SUPABASE_KEY = import.meta.env.VITE_SUPABASE_KEY
    import type { User } from '@supabase/supabase-js';
    import { writable } from 'svelte/store';
    const supabase: SupabaseClient = createClient(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_KEY);
    const user: any = writable<User | null>(null);
    let email = '';
    let password = '';

    supabase.auth.onAuthStateChange(async (event, session) => {
        console.log('onAuthStateChange', event, session)
        user.set(session?.user ?? null);
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
    <p>Custom claims: {$user.claims}</p>
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

<pre>

    {JSON.stringify($user, null, 2)}

</pre>
