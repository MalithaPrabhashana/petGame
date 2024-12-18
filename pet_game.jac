import:py random;

walker Pet {
    has name: str = "";
    has hunger: int = 50;
    has happiness: int = 70;
    has energy: int = 100;

    can ask_name with `root entry;

    can check_status {
        print(f"{self.name}'s Status");
        print(f"Hunger Level = {self.hunger}");
        print(f"Happiness Level = {self.happiness}");
        print(f"Energy Level = {self.energy}");
    }
    
    can check_win {
        if self.hunger >= 100 or self.happiness <= 0 or self.energy <= 0 {
            print(f"{self.name} is dead! Game Over!");
            disengage;
        }

        if self.hunger <= 20 and self.happiness >= 80 and self.energy >= 80 {
            print(f"{self.name} is happy and healthy! You win!");
            disengage;
        }
    }
}

node Start {
    can start_game with Pet entry;
}

node feed {
    can eat with Pet entry {
        print(
            "Food Items: \n 1. Chicken \n 2. Vegetable \n 3. fish"
        );

        food_no: int = "Enter the Food number: " |> input |> int;

        if food_no == 1 {
            visit [-->](`?chicken);
        } elif food_no == 2 {
            visit [-->](`?vegetable);
        } elif food_no == 3 {
            visit [-->](`?fish);
        }

    }
}

node sleep {
    can do_sleeping with Pet entry;
}

node play {
    can play_games with Pet entry {
        print(
            "Activities can do: \n 1. Touch Head \n 2. PLay with Ball "
        );

        activity_no: int = "Enter the Food number: " |> input |> int;

        if activity_no== 1 {
            visit [-->](`?touchHead);
        } elif activity_no == 2 {
            visit [-->](`?playBall);
        }

    }
}
node check_status {
    can print_status with Pet entry;
}

#------------ Nodes for Foods ----------------------------#

node chicken {
    can eat_chicken with Pet entry;
}

node vegetable {
    can eat_vegetable with Pet entry;
}
node fish {
    can eat_fish with Pet entry;
}


#------------- Nodes for Play ---------------------------#

node touchHead {
    can play_results with Pet entry;
}
node playBall {
    can play_results with Pet entry;
}



#----------------- Game Starting ----------------------#
:walker:Pet:can:ask_name {
    print(f"Welcome to the Pet Game! Meet your pet!");

    pet_name: str = "Enter you pet's name: " |> input;
    self.name = pet_name;
    
    visit [-->];
}


:node:Start:can:start_game {

    here.check_win();

    print(
        "Select an Activity: \n 1. Feed, \n 2. Play, \n 3. Sleep, \n 4. Check_status, \n 5. Exit"
    );

    input_activity: int = "Enter the Option number: " |> input |> int;

    if input_activity == 1 {
        visit [-->](`?feed);
    } elif input_activity == 2 {
        visit [-->](`?play);
    } elif input_activity == 3 {
        visit [-->](`?sleep);
    } elif input_activity == 4 {
        visit [-->](`?check_status);
    } elif input_activity == 5 {
        disengage;
    }
}



#----------------- See Status ----------------------#
:node:check_status:can:print_status {
    print("Pet Status");
    print(f"Hunger Level = {here.hunger}");
    print(f"Happiness Level = {here.happiness}");
    print(f"Energy Level = {here.energy}");
    visit start;
}


#----------------- Play Results ----------------------#
"""play increases happiness and decreases energy. And those values are randomly generated"""

:node:touchHead:can:play_results {
    random_happiness: int = random.randint(10, 20);
    random_energy: int = random.randint(5, 10);

    print(f"Happiness Level increased by {random_happiness}");
    print(f"Energy Level decreased by {random_energy}");

    here.happiness += random_happiness;
    here.energy -= random_energy;

    here.check_status();
    
    visit start;
}

:node:playBall:can:play_results {
    random_happiness: int = random.randint(15, 25);
    random_energy: int = random.randint(10, 20);

    print(f"Happiness Level increased by {random_happiness}");
    print(f"Energy Level decreased by {random_energy}");

    here.happiness += random_happiness;
    here.energy -= random_energy;

    here.check_status();
    
    visit start;
}


#----------------- Food Results ----------------------#
:node:chicken:can:eat_chicken {
    random_hunger: int = random.randint(10, 20);
    random_energy: int = random.randint(5, 10);

    print(f"Hunger Level decreased by {random_hunger}");
    print(f"Energy Level increased by {random_energy}");

    here.hunger -= random_hunger;
    here.energy += random_energy;

    # checking status using walker check status ability
    here.check_status();

    visit start;
}


:node:vegetable:can:eat_vegetable {
    random_hunger: int = random.randint(5, 10);
    random_energy: int = random.randint(5, 10);

    print(f"Hunger Level decreased by {random_hunger}");
    print(f"Energy Level increased by {random_energy}");

    here.hunger -= random_hunger;
    here.energy += random_energy;

    # checking status using walker check status ability
    here.check_status();

    visit start;
}


:node:fish:can:eat_fish {
    random_hunger: int = random.randint(15, 25);
    random_energy: int = random.randint(10, 20);

    print(f"Hunger Level decreased by {random_hunger}");
    print(f"Energy Level increased by {random_energy}");

    here.hunger -= random_hunger;
    here.energy += random_energy;

    # checking status using walker check status ability
    here.check_status();

    visit start;
}


#----------------- Sleep Results ----------------------#
"""play increases energy and increases hunger. And those values are randomly generated"""
:node:sleep:can:do_sleeping {
    random_energy: int = random.randint(20, 30);
    random_hunger: int = random.randint(5, 10);

    print(f"Energy Level increased by {random_energy}");
    print(f"Hunger Level increased by {random_hunger}");

    here.energy += random_energy;
    here.hunger += random_hunger;

    # checking status using walker check status ability
    here.check_status();

    visit start;
}


with entry {
    eat_food = feed();
    play_games = play();
    start = Start();

    root ++> start;

    start ++> eat_food;
    start ++> play_games;
    start ++> sleep();
    start ++> check_status();

    eat_food ++> chicken();
    eat_food ++> vegetable();
    eat_food ++> fish();

    play_games ++> touchHead();
    play_games ++> playBall();

    root spawn Pet();
}