export interface Weapon extends PartialWeaponData {
    owner: string;
    notes?: string;
    image?: string;
    class: string;
    knownInformation: string[];
}

export interface PartialWeaponData {
    model: string;
    serial: string;
}