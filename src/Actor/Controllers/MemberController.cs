using SevenSeals.Tss.Actor.Storage;
using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor.Controllers;

public class MemberController : ProtoStorageController<Member, Guid, IActorStorage, Member, Member>
{
    public MemberController(IActorStorage storage, Settings settings) : base(storage, settings)
    {
    }
}
