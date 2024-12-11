import {
	rem,
	Input,
	Divider,
	Text,
	ScrollArea,
	Center,
	Loader,
} from "@mantine/core";
import { IconSearch, IconSword } from "@tabler/icons-react";
import "../index.css";
import { useState, useEffect } from "react";
import { PartialWeaponData } from "../../../../../typings";
import locales from "../../../../../locales";
import useWeaponsStore from "../../../../../stores/weapons/weapons";
import { capitalizeFirstLetter } from "../../../../../helpers";

interface WeaponListProps {
	handleWeaponClick: (weapon: PartialWeaponData) => void;
}

const WeaponList = (props: WeaponListProps) => {
    const [searchQuery, setSearchQuery] = useState("");
	const { getWeapons } = useWeaponsStore();
	const [weapons, setWeapons] = useState<PartialWeaponData[]>([]);
	const [filteredWeapons, setFilteredWeapons] =
		useState<PartialWeaponData[]>(weapons);
	const [isLoading, setIsLoading] = useState(false);

    useEffect(() => {
		setIsLoading(true);
		const fetchData = async () => {
			return await getWeapons();
		};

		fetchData().then((data) => {
			setWeapons(data);
			setFilteredWeapons(data);
			setIsLoading(false);
		});
	}, []);

    useEffect(() => {
		if (searchQuery.trim() === "") {
			setFilteredWeapons(weapons);
		} else {
			const results = weapons.filter(
				(weapon) =>
					(weapon.serial || "")
						.toLowerCase()
						.includes(searchQuery.toLowerCase()) ||
					(weapon.model || "")
						.toLowerCase()
						.includes(searchQuery.toLowerCase())
			);
			setFilteredWeapons(results);
		}
	}, [searchQuery, filteredWeapons]);

    return (
		<div className='weapon-content-list-width'>
			<div className='card-background'>
				<div className='card-title'>
					<Text style={{ fontSize: 17, color: "white" }} weight={500}>
						{locales.weapons}
					</Text>

					<IconSword size={rem(25)} color='white' />
				</div>

				<Input
					icon={<IconSearch />}
					variant='filled'
					placeholder={locales.search}
					mt={10}
					mb={10}
					value={searchQuery}
					onChange={(e) => setSearchQuery(e.target.value)}
				/>

				<Divider mt={5} mb={5} />

				<div className='Weapons-card-content'>
					<ScrollArea h={860}>
						<div className='Weapons-card-content-flex'>
							{isLoading ? (
								<Center h={"100%"}>
									<Loader />
								</Center>
							) : (
								filteredWeapons.length > 0 &&
								filteredWeapons.map((weapon) => (
									<div
										className='weapons-card'
										onClick={() => props.handleWeaponClick(weapon)}
										key={weapon.serial}
									>
										<Text weight={600} style={{ fontSize: 14, color: "white" }}>
											{capitalizeFirstLetter(weapon.model)}
										</Text>

										<Text weight={500} style={{ fontSize: 10, color: "white" }}>
											{weapon.serial}
										</Text>
									</div>
								))
							)}
						</div>
					</ScrollArea>
				</div>
			</div>
		</div>
	);
}

export default WeaponList;