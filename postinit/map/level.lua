local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

local _ChooseTasks = Level.ChooseTasks
Level.ChooseTasks = function(self, ...)
    _ChooseTasks(self, ...)

    if self.selectedtasks then
        for _, selectedtask in ipairs(self.selectedtasks) do
            local numtoadd = math.random(selectedtask.min, selectedtask.max)
            shuffleArray(selectedtask.task_choices)

            for i = 1, numtoadd do
                self:EnqueueATask(self.chosen_tasks, selectedtask.task_choices[i])
            end
        end
    end

    -- is there enough place for set_pieces?
    if self.set_pieces then
        for name, choicedata in pairs(self.set_pieces or {}) do
            local availabletasks = {}

            for i, task in ipairs(self.chosen_tasks) do
                availabletasks[i] = task.id
            end

            local choices = ArrayIntersection(choicedata.tasks, availabletasks)
            local count = choicedata.count or 1

            if #choices < count then  -- reselect task
                print("Warning! could not find enough to place set_pieces")
                self:ChooseTasks(...)
            end
        end
    end
end
