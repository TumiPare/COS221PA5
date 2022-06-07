import {Event} from './event';
export class Tournament{
    roundof16: Array<Event>[8];
    quarterFinals: Array<Event>[4];
    semiFinals: Array<Event>[2];
    final: Event;
    fightFor3: Event;
    constructor(roundof16: Array<Event>[8], quarterFinals: Array<Event>[4], semiFinals: Array<Event>[2],
            final: Event, fightFor3: Event){

            this.roundof16 = roundof16;
            this.quarterFinals = quarterFinals;
            this.semiFinals = semiFinals;
            this.final = final;
            this.fightFor3 = fightFor3;
    }
}
