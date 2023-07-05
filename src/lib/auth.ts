import { supabase } from '../lib/supabase';
import type { User } from '@supabase/supabase-js';
import { writable } from 'svelte/store';
import { onMount } from 'svelte'
export const user: any = writable<User | null>(null);
supabase.auth.onAuthStateChange(async (event, session) => {
    console.log('onAuthStateChange', event, session)
    user.set(session?.user ?? null);
});  
export const signin = async (email: string, password: string) => {
    const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
    })
}
export const signup = async (email: string, password: string) => {
    const { data, error } = await supabase.auth.signUp({
        email,
        password,
    })
}
export const signout = async () => {
    const { error } = await supabase.auth.signOut();
}
