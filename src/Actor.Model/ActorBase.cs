﻿using SevenSeals.Tss.Shared;

namespace SevenSeals.Tss.Actor;

public abstract class ActorBase: StructuralItem<Guid>, IProtoRequest, IProtoResponse;
