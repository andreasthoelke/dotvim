import { Posts as testIdentif } from '../scratch/gqlBasicTests'

export function RunPrint() {
  new Promise( (r) => r( testIdentif ) ).then( res => console.log( res ) )
}












