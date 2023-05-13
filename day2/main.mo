// 0. Import the type `Time` for the `Time` library.
import Time "mo:base/Time";
import Bool "mo:base/Bool";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";

actor HomeworkDiary {
    type Homework = {
        title : Text;
        description : Text;
        dueDate : Time.Time;
        completed : Bool;
    };

    var homeworkDiary = Buffer.Buffer<Homework>(0);

    // Add a new homework task
    public shared func addHomework(homework : Homework) : async Nat {
        var size = homeworkDiary.size();
        homeworkDiary.add(homework);
        return size;
    };

    // Get a specific homework task by id
    public shared query func getHomework(id : Nat) : async Result.Result<Homework, Text> {
        if (id < homeworkDiary.size()) {
            // return Result.ok(homeworkDiary.get(id));
            return #ok(homeworkDiary.get(id));
        } else {
            return #err("Invalid homework id");
        };
    };

    // Update a homework task's title, description, and/or due date
    public shared func updateHomework(id : Nat, homework : Homework) : async Result.Result<(), Text> {
        if (id < homeworkDiary.size()) {
            homeworkDiary.put(id, homework);
            return #ok();
        } else {
            return #err("Invalid homework id");
        };
    };

    // Mark a homework task as completed
    public shared func markAsCompleted(id : Nat) : async Result.Result<(), Text> {
        if (id < homeworkDiary.size()) {
            var tmp = homeworkDiary.get(id);
            var s : Homework = {
                title = tmp.title;
                description = tmp.description;
                dueDate = tmp.dueDate;
                completed = true;
            };

            homeworkDiary.put(id, s);
            return #ok();
        } else {
            return #err("Invalid homework id");
        };
    };

    // 7. Implement `deleteHomework`, which accepts a `homeworkId` of type `Nat`, removes the corresponding homework from the `homeworkDiary`, and returns a unit value wrapped in an `Ok` result. If the `homeworkId` is invalid, the function should return an error message wrapped in an `Err` result.
    // Delete a homework task by id
    public shared func deleteHomework(id : Nat) : async Result.Result<(), Text> {
        if (id < homeworkDiary.size()) {
            let s = homeworkDiary.remove(id);
            return #ok();
        } else {
            return #err("Invalid homework id");
        };
    };

    // 8. Implement `getAllHomework`, which returns the list of all homework tasks in `homeworkDiary`.
    // Get the list of all homework tasks
    public shared query func getAllHomework() : async [Homework] {
        return Buffer.toArray(homeworkDiary);
    };

    // 9. Implement `getPendingHomework` which returns the list of all uncompleted homework tasks in `homeworkDiary`.
    // Get the list of pending (not completed) homework tasks
    public shared query func getPendingHomework() : async [Homework] {
        var homeworkCopy = homeworkDiary;
        homeworkCopy.filterEntries(func(_, homework) = not homework.completed or (homework.completed == false));
        return Buffer.toArray(homeworkCopy);
    };

    // 10. Implement a `searchHomework` query function that accepts a `searchTerm` of type `Text` and returns a list of homework tasks that have the given `searchTerm` in their title or description.
    // Search for homework tasks based on a search terms
    public shared query func searchHomework(searchTerm : Text) : async [Homework] {
        var homeworkCopy = homeworkDiary;
        homeworkCopy.filterEntries(func(_, homework) = Text.contains(homework.title, #text searchTerm) or Text.contains(homework.description, #text searchTerm));
        return Buffer.toArray(homeworkCopy);
    };
};
