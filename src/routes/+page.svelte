<script lang="ts">
    import { supabase } from '../lib/supabase';
    import type { User } from '@supabase/supabase-js';
    import { user, signin, signup, signout } from '../lib/auth';
	import { onMount } from 'svelte'
    let email = '';
    let password = '';
    let claims: any = null;
    let headers: any = null;
    let titles: any = [];
    onMount(async () => {
        const { data, error } = await supabase.rpc('headers');
        if (error) { console.error('headers() error', error)}
        else {headers = data; console.log('headers', data);}

    });
    const set_titles = async () => {
        const { data: titles_result, error: titles_error } = 
            await supabase.from('title').select('*');
        if (titles_error) { console.error('titles error', titles_error)}
        else {console.log('titles', titles); titles = titles_result;}
    }
    const set_claims = async () => {
        const { data, error } = await supabase.rpc('req');
        if (error) { console.error('set_claims error (req)', error)}
        else {claims = data; console.log('claims', claims);}
    }
    user.subscribe((value: User) => {
        console.log('user', value);
        // if (value) {
            set_claims();
            set_titles();
        // }
    });

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
                <button on:click={()=>{signin(email,password)}}>Login</button>
            </td>
        </tr>
        <tr>
            <td>
                <button on:click={()=>{signup(email,password)}}>Sign Up</button>
            </td>
        </tr>
    </table>
    </form>
{/if}

<br/><br/>claims:<pre>{JSON.stringify(claims, null, 2)}</pre>
$user:<pre>{JSON.stringify($user, null, 2)}</pre>
headers:<pre>{JSON.stringify(headers, null, 2)}</pre>
titles:<pre>{JSON.stringify(titles, null, 2)}</pre>

