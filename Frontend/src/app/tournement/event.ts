export class Event{
    teamA: string;
    teamB: string;
    scoreA: number;
    scoreB: number;
    picA: string;
    picB: string;
    date: string;
    eventNumber: number;
    constructor(teamA: string, teamB: string, scoreA: number, scoreB: number, eventNumber: number, picA: string, picB: string){
        this.teamA = teamA;
        this.teamB = teamB;
        this.scoreA = scoreA;
        this.scoreB = scoreB;
        this.picA = picA;
        this.picB = picB;
        this.eventNumber = eventNumber;
    }
}